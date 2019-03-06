import UIKit

let isAcceptanceTestsRunning = ProcessInfo.processInfo.environment["IsAutomationTestsRunning"] != nil
let appDelegateClass: AnyClass = isAcceptanceTestsRunning ? AutomationTestsApplicationDelegate.self : AppDelegate.self
let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
.bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
