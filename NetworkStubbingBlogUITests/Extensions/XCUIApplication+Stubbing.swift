import Foundation
import XCTest

extension XCUIApplication {
    
    func startRecordingStubs(for testCase: XCTestCase, file: StaticString = #file, line: UInt = #line) {
        setupFileStubs(for: testCase, recordingMode: .recording, file: file, line: line)
    }
    
    func replayStubs(for testCase: XCTestCase, file: StaticString = #file, line: UInt = #line) {
        setupFileStubs(for: testCase, recordingMode: .replaying, file: file, line: line)
    }
    
    private func setupFileStubs(for testCase: XCTestCase, recordingMode: RecordMode, file: StaticString = #file, line: UInt = #line) {
        let testName = String(describing: testCase)
        setEnvironmentValue(recordingMode.rawValue, forKey: .recordMode)
        setEnvironmentValue(testName, forKey: .stubbedTestName)
        if let networkStubsDir = networkStubsDirURL(file: file, line: line) {
            setEnvironmentValue(networkStubsDir.path, forKey: .networkStubsDir)
        }
    }
    
    private func networkStubsDirURL(file: StaticString, line: UInt = #line) -> URL? {
        let filePath = file.description
        guard let range = filePath.range(of: "AutomationTests/", options: [.literal]) else {
            XCTFail("AutomationTests directory does not exist!", file: file, line: line)
            return nil
        }
        let testsDirIndex = filePath.index(before: range.upperBound)
        let automationTestsPath = filePath[..<testsDirIndex]
        return URL(fileURLWithPath: String(automationTestsPath)).appendingPathComponent("NetworkStubs", isDirectory: true)
    }
}

extension XCUIApplication {
    func setEnvironmentValue(_ environmentValue: String, forKey key: EnvironmentKey) {
        var launchEnv = launchEnvironment
        launchEnv[key.rawValue] = environmentValue
        launchEnvironment = launchEnv
    }
}

