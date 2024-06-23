import Foundation
import NotificationCenter

class PushNotificationManager: NSObject {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        
        notificationCenter.delegate = self
    }
    
    public func registerForNotifications() async throws -> Bool {
        try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
    }
    
    public func getNotificationSettings() async -> UNNotificationSettings {
        await notificationCenter.notificationSettings()
    }
    
}

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
    
}
