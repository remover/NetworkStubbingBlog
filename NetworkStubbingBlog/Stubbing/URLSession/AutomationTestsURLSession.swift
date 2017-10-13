import Foundation
import UIKit

class AutomationTestsURLSession: NSObject, URLSessionManaging {
    
    private let environment = Environment()
    private let _session = URLSession(configuration: .default)
    private let testStubsRecorder = TestStubsRecorder()
    
    func dataTaskFromRequest(_ request: URLRequest, completionHandler: @escaping CompletionBlock) -> URLSessionDataTasking {
        
        if environment.isRecordingStubs {
            let completion = testStubsRecorder.recordResult(of: request, with: completionHandler)
            return _session.dataTask(with: request, completionHandler: completion)
        }
        
        if shouldStub(request) {
            return AutomationTestsDataTask(request: request, completion: completionHandler)
        }
        
        return _session.dataTask(with: request, completionHandler: completionHandler)
    }
    
    
    private func shouldStub(_ request: URLRequest) -> Bool {
        return NetworkResponseStubStorage().stubExists(for: request)
    }
    
}
