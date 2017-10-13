import Foundation

public enum EnvironmentKey: String {
    case stubbedTestName
    case networkStubsDir
    case recordMode
}

public enum RecordMode: String {
    case recording
    case replaying
}
