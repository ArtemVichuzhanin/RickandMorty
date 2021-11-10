import Foundation
import UIKit
import UserNotifications

class CustomNotifications: NSObject, CustomNotificationsDelegate {
  static let shared = CustomNotifications()

  let notificationCenter = UNUserNotificationCenter.current()
  var currentBadgeCount = 0

  private var badgeCount: Int {
    get {
      return getBadge()
    }
    set {
      setBadge(newValue)
    }
  }

  private override init() {
    super.init()
    notificationCenter.delegate = self
  }

  func setBadge(_ newValue: Int) {
    DispatchQueue.main.async {
      UIApplication.shared.applicationIconBadgeNumber = newValue
    }
  }

  func getBadge() -> Int {
    DispatchQueue.main.async {
      self.currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
    }
    return currentBadgeCount
  }

  func resetBadgeCount() {
    self.setBadge(0)
  }

  func requestAuth() {
    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
      print(error?.localizedDescription ?? "")
    }
  }

  func sendNotification(with delay: Double) {
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)

    let requestNotification = UNNotificationRequest(
      identifier: "Rick and Morty",
      content: self.configureContent(),
      trigger: trigger
    )

    self.notificationCenter.add(requestNotification) { error in
      print(error?.localizedDescription ?? "")
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
