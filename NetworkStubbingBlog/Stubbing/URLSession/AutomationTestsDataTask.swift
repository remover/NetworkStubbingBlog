import Foundation

typealias DataCompletion = (Data?, URLResponse?, Error?) -> Void

class AutomationTestsDataTask: URLSessionDataTasking {
    private let request: URLRequest
    private let completion: DataCompletion
    
    init(request: URLRequest, completion: @escaping DataCompletion) {
        self.request = request
        self.completion = completion
    }
    
    func resume() {
        if let jsonData = NetworkResponseStubStorage().stub(for: request),
            let url = request.url {
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            completion(jsonData, response, nil)
        }
    }
    
    func cancel() { }
    func suspend() { }
}
