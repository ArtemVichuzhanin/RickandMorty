import Foundation

protocol CustomNotificationsDelegate: AnyObject {
  func requestAuth()
  func sendNotification(with delay: Double)
  func resetBadgeCount()
}
