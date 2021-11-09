import Foundation

protocol CustomNotificationsDelegate: AnyObject {
  func requestAuth() -> Bool
  func sendNotification(with delay: Double)
}
