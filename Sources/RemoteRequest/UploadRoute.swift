//
//  UploadRoute.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 09.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

private class UploadDelegate: NSObject, URLSessionTaskDelegate {
    var progressHandler: ((Double) -> Void)?
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let fractionCompleted = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        progressHandler?(fractionCompleted)
    }
}

extension Route {
    
    public func uploadTask(with request: URLRequest, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask? {
        guard let inputFile = inputFile else {
            completionHandler(nil, nil, NSError(domain: "FormDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty multipart form data"]))
            return nil
        }
        var req = request
        let boundary = "Boundary-\(UUID().uuidString)"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let multipartFormData = self.createMultipartFormDataWithFile(inputFile, boundary: boundary)
        
        let delegate = UploadDelegate()
        delegate.progressHandler = progressHandler
     
        let task = URLSession.shared.uploadTask(with: req, from: multipartFormData.httpBody) { data, response, error in
            completionHandler(data, response, error)
        }
        if #available(iOS 15.0, *) {
            task.delegate = delegate
        }
        
        return task
    }
    
    private func createMultipartFormDataWithFile(_ file: InputFile, boundary: String) -> MultipartFormData {
        var formData = Data()
        
        formData += "--\(boundary)\r\n".data(using: .utf8) ?? Data()
        formData += "Content-Disposition: form-data; name=\"\(file.fileKey)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8) ?? Data()
        formData += "Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8) ?? Data()
        formData += file.data
        formData += "\r\n".data(using: .utf8) ?? Data()
        
        formData += "--\(boundary)--\r\n".data(using: .utf8) ?? Data()
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        
        return MultipartFormData(httpBody: formData, contentType: contentType)
    }
}
