//
//  Route.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Route<Output: Decodable, MappableOutput>: RouteRestProtocol, RouteUploadProtocol {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    var parameters: [String: Any]?
    var body: InputBodyObject?
    var inputFile: InputFile?
    
    public var wrappedValue: URLRequest {
        var urlComponents = URLComponents(string: path)
        if let parameters = parameters {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        }
        
        guard let url = urlComponents?.url else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if method != .get,
           let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return request
    }
    
    public init(_ path: String, method: HTTPMethod, headers: [String: String] = [:], parameters: [String: Any]? = nil, body: InputBodyObject? = nil, inputFile: InputFile? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.body = body
        self.inputFile = inputFile
    }
    
    public func runRequest<MappableOutput>(completion: @escaping (ResultData<MappableOutput>) -> Void) {
        let task = URLSession.shared.dataTask(with: wrappedValue) { data, response, error in
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
        task.resume()
    }
    
    public func runUploadRequest<MappableOutput>(completion: @escaping (ResultData<MappableOutput>) -> Void, progressHandler: ((Double) -> Void)? = nil) {
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
    
    // MARK: - Async/await
    @available(iOS 15.0, *)
    public func runRequest<MappableOutput>() async throws -> Result<MappableOutput, Error> {
        do {
            let (data, response) = try await URLSession.shared.data(for: wrappedValue)
            do {
                let result: MappableOutput = try self.handleRequestResult(data: data, response: response)
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
        print("Response - \(response)")
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
                throw error
            } else {
                let error = NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown HTTP Error"])
                throw error
            }
        }
        
        if let data = data {
            if let bodyStr = String(data: data, encoding: .utf8) {
                print("Result body - \(bodyStr)")
            }
            do {
                let decodedData = try JSONDecoder().decode(Output.self, from: data)
                let model = self.tryCreateOutputModel(from: decodedData)
                if let model = model as? MappableOutput {
                    return model
                } else {
                    let error = NSError(domain: "MappingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to map response"])
                    throw error
                }
            } catch {
                throw error
            }
        } else {
            let error = NSError(domain: "EmptyResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response"])
            throw error
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
