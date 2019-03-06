import Foundation
import UIKit

typealias CompletionBlock = (Data?, URLResponse?, Error?) -> Void

final class TestStubsRecorder {
    
    private let environment = Environment()
    private let networkResponseStubStorage = NetworkResponseStubStorage()
    private let fileManager = FileManager.default
    
    func recordResult(of request: URLRequest, with completionHandler: @escaping CompletionBlock) -> CompletionBlock {

        let completionWrapper: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            do {
                try self.record(data, response, error, for: request)
            } catch {
                print("TestStubsRecorder error: \(error)")
            }
            completionHandler(data, response, error)
        }
        return completionWrapper
    }
    
    private func record(_ data: Data?, _ response: URLResponse?, _ error: Error?, for request: URLRequest) throws {
        guard let testName = environment[.stubbedTestName] else {
            throw  TestStubsRecorderError.noStubbedTestName
        }
        
        guard error == nil else {
            throw  TestStubsRecorderError.networkError(error!)
        }
        
        guard let data = data else {
            throw  TestStubsRecorderError.invalidResponseData
        }
        
        try createTestCaseDirIfRequired(forTestName: testName)
        
        let stubPath = try makeTestStubPath(forTestName: testName, request: request)
        
        fileManager.createFile(atPath: stubPath.path, contents: data, attributes: nil)
    }
    
    private func createTestCaseDirIfRequired(forTestName testName: String) throws {
        let dirPath = networkResponseStubStorage.testDirPath(forTestName: testName)
        if !fileManager.fileExists(atPath: dirPath.path) {
            try fileManager.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private func makeTestStubPath(forTestName testName: String, request: URLRequest) throws -> URL {
        let stubPath = try networkResponseStubStorage.testStubPath(forTestName: testName, request: request)
        if fileManager.fileExists(atPath: stubPath.path) {
            try fileManager.removeItem(at: stubPath)
        }
        return stubPath
    }
}

