import Foundation
import UIKit
import ApphudSDK
import OneSignalFramework
import AppMetricaCore


class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Apphud.start(apiKey: "app_7haNrqMd9qE4pTRARJVaemfjjxpqXz")
        
        OneSignal.initialize("3ed7a85c-6ede-453f-9ba9-8930d1c0c4ff", withLaunchOptions: launchOptions)

        let configuration = AppMetricaConfiguration.init(apiKey: "1042b9e4-fd56-4085-a33f-288701ef2a6b")
        AppMetrica.activate(with: configuration!)
        
        
        return true
    }
}
