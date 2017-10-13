import Foundation
import UIKit

typealias NetworkResponse = (data: Data?, response: URLResponse?, error: Error?)
typealias CompletionBlock = (Data?, URLResponse?, Error?) -> Void

final class TestStubsRecorder {
    
    private let environment = Environment()
    private let networkResponseStubStorage = NetworkResponseStubStorage()
    private let fileManager = FileManager.default
    
    func recordResult(of request: URLRequest, with completionHandler: @escaping CompletionBlock) -> CompletionBlock {
        
        func completionWrapper(networkResponse: NetworkResponse) {
            do {
                try record(networkResponse: networkResponse, for: request)
                
            } catch {
                print("TestStubsRecorder error: \(error)")
            }
            completionHandler(networkResponse.data, networkResponse.response, networkResponse.error)
        }
        
        return completionWrapper
    }
    
    private func record(networkResponse: NetworkResponse, for request: URLRequest) throws {
        guard let testName = environment[.stubbedTestName] else {
            throw  TestStubsRecorderError.noStubbedTestName
        }
        
        guard networkResponse.error == nil else {
            throw  TestStubsRecorderError.networkError(networkResponse.error!)
        }
        
        guard let data = networkResponse.data else {
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

