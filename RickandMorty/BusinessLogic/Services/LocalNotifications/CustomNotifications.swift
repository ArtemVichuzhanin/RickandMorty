import Foundation
import UIKit
import UserNotifications

class CustomNotifications: NSObject, CustomNotificationsDelegate {
  static var shared: CustomNotifications = {
    let instance = CustomNotifications()
    return instance
  }()

  let notificationCenter = UNUserNotificationCenter.current()

  var badgeCount: Int {
    get {
      return UIApplication.shared.applicationIconBadgeNumber
    }
    set {
      DispatchQueue.main.sync {
        UIApplication.shared.applicationIconBadgeNumber = newValue
      }
    }
  }

  private override init() {
    super.init()
    notificationCenter.delegate = self
  }

  func requestAuth() -> Bool {
    var accept = false

    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      accept = granted
      print(error?.localizedDescription ?? "")
    }
    return accept
  }

  func sendNotification(with delay: Double) {
    self.notificationCenter.getNotificationSettings { settings in
      if settings.authorizationStatus == .authorized {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)

        let requestNotification = UNNotificationRequest(
          identifier: "Rick and Morty",
          content: self.configureContent(),
          trigger: trigger
        )

        self.notificationCenter.add(requestNotification) { error in
          print(error?.localizedDescription ?? "")
        }
      } else {
        guard self.requestAuth() else {
          print("request to send notifications denied")
          return
        }
        self.sendNotification(with: delay)
      }
    }
  }

  func configureContent() -> UNNotificationContent {
    let content = UNMutableNotificationContent()

    content.title = "Эй, ты где?"
    content.body = "Мы по тебе уже так соскучились!"
    content.sound = .default
    content.badge = badgeCount + 1 as NSNumber

    return content
  }
}

extension CustomNotifications: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}

// MARK: - Extension UNUserNotificationCenterDelegate

extension CustomNotifications: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    badgeCount = 0
  }
}
