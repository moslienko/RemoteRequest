<p align="center">
   <img width="200" src="https://moslienko.github.io/Assets/RemoteRequestApp/sdk.png" alt="RemoteRequest Logo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat" alt="Swift 5.2">
   </a>
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
</p>

# RemoteRequest

<p align="center">
Library for creating and sending requests to a remote server
</p>

## Table of Contents

* [Features](#features)
* [Example](#example)
* [Installation](#installation)
* [Usage](#usage)
  * [Rest request](#rest-request)
  * [Upload file](#upload-file)
  * [Async/await](#asyncawait)
  * [Headers](#headers)
  * [Configuration](#configuration)
  * [Cashing](#cashing)

## Features

- [x] Create Rest requests
- [x] Create file upload requests
- [x] Custom error handling
- [x] Async/await
- [x] Cache request answers
- [x] Logging
- [x] Configuring parameters

For fast code generation it is recommended to use the [Remote Request Application](https://github.com/moslienko/RemoteRequestApp/).

## Example

The example application is the best way to see `RemoteRequest` in action. Simply open the `RemoteRequest.xcodeproj` and run the `Example` scheme.

## Installation
### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/moslienko/RemoteRequest.git", from: "1.0.0")
]
```

Alternatively navigate to your Xcode project, select `Swift Packages` and click the `+` icon to search for `RemoteRequest`.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate RemoteRequest into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage

### Rest request

The request is created through the property wrapper `@Route`.

```swift
struct Route<Output: Decodable, MappableOutput, ErrorType: RestError>: RouteRestProtocol, RouteUploadProtocol {
    init(
        _ path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        parameters: [String: Any]?,
        body: InputBodyObject?,
        inputFile: InputFile?,
        options: RouteOptions)
}
```

Three parameters are passed to the wrapper:
 - Responce model: `ObjectMappable`:

```swift
protocol ObjectMappable: Codable {
    associatedtype MappableOutput
    func createModel() -> MappableOutput?
}
```

 - Domain layer model into which the response is mapped.
 - Responds to server error handling: `RestError`:

```swift
protocol RestError: Error, Codable {}
```

You can use your own class or existing ones in the library.

```swift
typealias RegRestErrorResponse = RestErrorResponse<String?>

struct RestErrorResponse<T: Codable>: RestError {
    let code: Int
    let message: String
    let data: T?
}
```

Example:

```swift
func fetchPost(postID: Int, completion: @escaping(ResultData <PostModel>) -> Void) {
     @Route<PostResponse, PostModel, RegRestErrorResponse>(Routes.baseURL + "/posts/\(postID)", method: .get)
     var fetchPost: URLRequest
     _fetchPost.runRequest(completion: completion)
 }
```

To simplify the syntax, it is recommended to use the following property wrappers, which already have a query method built in: `@GET`, `@POST`, `@PATCH`, `@PUT`, `@DELETE`.

Parameters that are passed to the request and will be sent in the body of the request must conform to the protocol `InputBodyObject`.

Example:

```swift
func createPost(_ postRequest: CreatePostRequest, completion: @escaping(ResultData<IdendifierModel>) - > Void) {
    @POST<IdendifierResponse, IdendifierModel, RegRestErrorResponse> (Routes.baseURL + "/posts", body: postRequest)
    var createPost: RouteRestProtocol
    createPost.runRequest(completion: completion)
}
```

### Upload file

Create a request through the property wrapper `@UPLOAD`.

```swift
@UPLOAD<EmptyResponse, Any, RegRestErrorResponse>("/upload", inputFile: file)
var uploadPost: RouteUploadProtocol
```

```swift
protocol RouteUploadProtocol {
    func runUploadRequest<MappableOutput>(completion: @escaping (ResultData<MappableOutput>) -> Void, progressHandler: ((Double) -> Void)?)
}
```

Or, you can create such a request via `Route`.

```swift
@Route<EmptyResponse, Any, RegRestErrorResponse>("/upload", method: .post, inputFile: file)
var uploadPost: URLRequest
```

During initialization, pass information about the file to be uploaded to `inputFile`.

```swift
struct InputFile {
    let data: Data
    let filename: String
    let fileKey: String
    let mimeType: String
}
```

### Async/await

The request is created as usual, only you need to change the call of the `runRequest` method.

```swift
@available(iOS 15.0, *)
func fetchPostsAwait() async throws -> Result <[PostModel], Error> {
    @Route<[PostResponse], [PostModel], RegRestErrorResponse>(Routes.baseURL + "/posts", method: .get)
    var fetchPost: URLRequest

    return try await _fetchPost.runRequest()
}
```

### Headers
Headers are passed to the initialization method in `[String: String]` format.

Example:

```swift
@Route<PostResponse, PostModel, RegRestErrorResponse>(Routes.baseURL + "/posts", method: .get, headers: ["AppClient": "iOS App 1.0.0"])
var fetchPosts: URLRequest
```

Another way is to create a structure where the header variable has the property wrapper `@Header`. For example:

```swift
struct SampleHeaders {
    @Header(.jwtAuth("eyJhbG..."))
    @Header(.custom(key: "AppClient", value: "iOS"))
    var header: [String: String] = [: ]

    init() {
        self.header = [:]
    }
}
```

So, you can create your own header or, if you need a header for authorization, use one of the existing initializers.

```swift
enum HeaderBuilder {
    case custom(key: String, value: String),
        tokenAuth(_ token: String),
        basicAuth(username: String, password: String),
        jwtAuth(_ jwtToken: String)
}
```

### Configuration

You can set configuration parameters for all requests at once, or you can separately set all or several parameters for one specific request.

```swift
struct RouteOptions {
    init(
        timeoutInterval: TimeInterval,
        isCompressionEnabled: Bool,
        loggingLevels: LoggingLevels,
        isNeedUseCache: Bool,
        additionalHeaders: [String: String]
    )
}
```

```swift
enum LoggingLevels {
	case all, errors, none
}
```

All parameters have their default values. If you want to change some parameter for all requests, configure it in the `RouteSessionOptions` singleton object.

```swift
RouteSessionOptions.current.options.loggingLevels = .all
```

And if you want your own settings to be applied for a specific request, just provide them when initializing the request.

```swift
@GET<PostResponse, PostModel, ErrorRespons>("/url", options: RouteOptions(loggingLevels: .errors))
var getPostsRequest: RouteRestProtocol
```

It means that in our example above, all requests will have full logging enabled, except for getPostsRequest, which has only error logging.

### Cashing

Configuring cache auto-deletion.

```swift
CacheManager.shared.shouldAutoCleanCache = true
CacheManager.shared.cacheExpirationInterval = 1600
```

And enable the `isNeedUseCache` parameter in `RouteOptions`.

```swift
@GET<[CommentResponse], [CommentModel], RegRestErrorResponse>(Routes.baseURL + "/posts/\(postId)/comments", options: RouteOptions(isNeedUseCache: true))
var request: RouteRestProtocol   
```

## License

```
RemoteRequest
Copyright (c) 2023 Pavel Moslienko 8676976+moslienko@users.noreply.github.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
