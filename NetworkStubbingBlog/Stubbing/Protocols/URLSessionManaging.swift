import Foundation
import UIKit

protocol URLSessionManaging: class {
    func dataTaskFromRequest(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTasking
}

protocol URLSessionDataTasking: class {
    func resume()
    func suspend()
    func cancel()
}

extension URLSession: URLSessionManaging {
    func dataTaskFromRequest(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTasking {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTasking
    }
}

extension URLSessionDataTask: URLSessionDataTasking {}
