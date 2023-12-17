//
//  Route.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Route<Output: Decodable, MappableOutput, ErrorType: RestError>: RouteRestProtocol, RouteUploadProtocol {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    var parameters: [String: Any]?
    var body: InputBodyObject?
    var inputFile: InputFile?
    
    var options: RouteOptions
    
    public var wrappedValue: URLRequest {
        getRequest()
    }
    
    public init(_ path: String, method: HTTPMethod, headers: [String: String] = [:], parameters: [String: Any]? = nil, body: InputBodyObject? = nil, inputFile: InputFile? = nil, options: RouteOptions = RouteSessionOptions.current.options) {
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.body = body
        self.inputFile = inputFile
        self.options = options
    }
    
    public func runRequest<MappableOutput>(completion: @escaping (ResultData<MappableOutput>) -> Void) {
        if options.loggingLevels == .all {
            wrappedValue.debug()
        }
        
        if let cache = self.tryGetCash() as? MappableOutput {
            completion(.success(cache))
            return
        }
        
        let task = URLSession.shared.dataTask(with: wrappedValue) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let result: MappableOutput = try self.handleRequestResult(data: data, response: response)
                    if let data = data {
                        self.trySaveCache(data)
                    }
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func runUploadRequest<MappableOutput>(completion: @escaping (ResultData<MappableOutput>) -> Void, progressHandler: ((Double) -> Void)? = nil) {
        if options.loggingLevels == .all {
            wrappedValue.debug()
        }
        
        let uploadTask = self.uploadTask(with: wrappedValue) { progress in
            progressHandler?(progress)
        } completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let result: MappableOutput = try self.handleRequestResult(data: data, response: response)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        uploadTask?.resume()
    }
    
    public func getRequest() -> URLRequest {
        var urlComponents = URLComponents(string: path)
        if let parameters = parameters {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        }
        
        guard let url = urlComponents?.url else {
            print("Invalid URL - \(String(describing: urlComponents))")
            return URLRequest(url: URL(fileURLWithPath: ""))
        }
        var requestHeaders = headers
        requestHeaders.merge(options.additionalHeaders) { (_, new) in new }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = requestHeaders
        request.timeoutInterval = options.timeoutInterval
        if options.isCompressionEnabled {
            request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        }
        
        if method != .get,
           let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return request
    }
    
    // MARK: - Async/await
    
    @available(iOS 15.0, *)
    public func runRequest<MappableOutput>() async throws -> Result<MappableOutput, Error> {
        if options.loggingLevels == .all {
            wrappedValue.debug()
        }
        
        if let cache = self.tryGetCash() as? MappableOutput {
            return .success(cache)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: wrappedValue)
            do {
                let result: MappableOutput = try self.handleRequestResult(data: data, response: response)
                trySaveCache(data)
                return .success(result)
            } catch {
                return .failure(error)
            }
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Module
private extension Route {
    
    func handleRequestResult<MappableOutput>(data: Data?, response: URLResponse?) throws -> MappableOutput {
        if options.loggingLevels == .all {
            print("Response - \(String(describing: response))")
        }
        if let data = data,
           let bodyStr = String(data: data, encoding: .utf8) {
            if options.loggingLevels == .all {
                print("Result body - \(bodyStr)")
            }
        }
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let httpResponse = response as? HTTPURLResponse {
                let error =
                NSError(
                    domain: "HTTPError",
                    code: httpResponse.statusCode,
                    userInfo: [
                        NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"
                    ]
                )
                if options.loggingLevels == .all || options.loggingLevels == .errors {
                    print(error.localizedDescription)
                }
                if let data = data {
                    //Try parce error
                    if let decodedError = try? JSONDecoder().decode(ErrorType.self, from: data) {
                        if options.loggingLevels == .all || options.loggingLevels == .errors {
                            print("Error - \(decodedError.localizedDescription)")
                        }
                        throw decodedError
                    }
                    throw error
                }
                throw error
            } else {
                let error = NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown HTTP Error"])
                if options.loggingLevels == .all || options.loggingLevels == .errors {
                    print(error.localizedDescription)
                }
                throw error
            }
        }
        
        if let data = data {
            do {
                let decodedData = try JSONDecoder().decode(Output.self, from: data)
                let model = self.tryCreateOutputModel(from: decodedData)
                if let model = model as? MappableOutput {
                    return model
                } else {
                    let error = NSError(domain: "MappingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to map response"])
                    if options.loggingLevels == .all || options.loggingLevels == .errors {
                        print(error.localizedDescription)
                    }
                    throw error
                }
            } catch {
                throw error
            }
        } else {
            let error = NSError(domain: "EmptyResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response"])
            if options.loggingLevels == .all || options.loggingLevels == .errors {
                print(error.localizedDescription)
            }
            throw error
        }
    }
    
    func tryGetCash() -> MappableOutput? {
        if options.isNeedUseCache,
           let url = self.wrappedValue.url,
           let cashedData: MappableOutput = self.getCashMappableObject(url: url) {
            return cashedData
        }
        return nil
    }
    
    func getCashMappableObject<MappableOutput>(url: URL) -> MappableOutput? {
        if let cachedData = CacheManager.shared.fetchDataFromCache(for: url),
           let decodedData = try? JSONDecoder().decode(Output.self, from: cachedData) {
            let model = self.tryCreateOutputModel(from: decodedData)
            return model as? MappableOutput
        }
        
        return nil
    }
    
    func trySaveCache(_ data: Data) {
        if options.isNeedUseCache,
           let url = self.wrappedValue.url {
            CacheManager.shared.saveDataToCache(data, for: url)
        }
    }
    
    func tryCreateOutputModel(from decodedData: Output) -> MappableOutput? {
        if let mappableModel = decodedData as? any ObjectMappable {
            let model = mappableModel.createModel()
            return model as? MappableOutput
        } else if let mappableModel = decodedData as? [any ObjectMappable] {
            var models: [Any] = []
            // Return only valid models
            mappableModel.forEach({
                if let model = $0.createModel() {
                    models += [model]
                }
            })
            
            return models as? MappableOutput
        }
        return nil
    }
}
