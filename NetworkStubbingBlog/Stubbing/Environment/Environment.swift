import Foundation

enum EnvironmentError: Error {
    case testDirURLCreationFailed
}

final class Environment {
    
    private let processInfo = ProcessInfo.processInfo
    
    var isRecordingStubs: Bool {
        guard let recordModelValue = self[.recordMode] else { return false }
        return recordModelValue == RecordMode.recording.rawValue
    }
    
    subscript(key: EnvironmentKey) -> String? {
        return processInfo.environment[key.rawValue]
    }
}
