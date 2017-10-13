import Foundation
import UIKit

class AutomationTestsApplicationDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

extension UIApplication {
    
    static var isAutomationTest: Bool {
        guard let delegate = UIApplication.shared.delegate, delegate is AutomationTestsApplicationDelegate else {
            return false
        }
        return true
    }
}
