import Foundation
import UIKit

enum Result<T> {
    case success(T)
    case failure(Error)
}

class Client {
    let session: URLSessionManaging
    
    init(session: URLSessionManaging = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult
    func makeRequest(_ request: URLRequest, completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTasking {
        let task = session.dataTaskFromRequest(request) { data, response, error in
            
            // handle potential errors
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
        return task
    }
}

final class ClientFactory {
    static func makeClient() -> Client {
        let session = makeSession()
        let client = Client(session: session)
        return client
    }
    
    private static func makeSession() -> URLSessionManaging {
        return UIApplication.isAutomationTest ? AutomationTestsURLSession() : URLSession.shared
    }
}

