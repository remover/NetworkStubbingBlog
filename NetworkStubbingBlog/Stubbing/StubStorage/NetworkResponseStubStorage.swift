import Foundation

final class NetworkResponseStubStorage {
    
    private let environment = Environment()
    private let fileManager = FileManager.default
    
    func stub(for request: URLRequest) -> Data? {
        guard stubExists(for: request) else { return nil }
        guard let testName = environment[.stubbedTestName] else { return nil }
        guard let stubPath = try? testStubPath(forTestName: testName, request: request) else { return nil }
        return fileManager.contents(atPath: stubPath.path)
    }
    
    func stubExists(for request: URLRequest) -> Bool {
        guard let testName = environment[.stubbedTestName] else {
            return false
        }
        
        let stubPath = try? testStubPath(forTestName: testName, request: request)
        guard let unwrappedPath = stubPath else { return false }
        
        return fileManager.fileExists(atPath: unwrappedPath.path)
    }
    
    fileprivate var networkStubsDir: URL {
        guard let url = baseStubsDirURL else {
            fatalError("Base stubs netowrk directory is not set!")
        }
        return url
    }
    
    fileprivate var baseStubsDirURL: URL? {
        guard let path = environment[.networkStubsDir] else { return nil }
        return URL(fileURLWithPath: path)
    }
}

extension NetworkResponseStubStorage {
    
    func testDirPath(forTestName testName: String) -> URL {
        return networkStubsDir.appendingPathComponent(testName, isDirectory: true)
    }
    
    func testStubPath(forTestName testName: String, request: URLRequest) throws -> URL {
        guard let url = request.sanitizedFileName() else {
            throw EnvironmentError.testDirURLCreationFailed
        }
        
        let testDir = testDirPath(forTestName: testName)
        return testDir.appendingPathComponent(url, isDirectory: false).appendingPathExtension("json")
    }
}

enum TestStubsRecorderError: Error {
    case noStubbedTestName
    case invalidResponseData
    case networkError(Error)
}
