import Foundation

protocol AppDataDelegate: AnyObject {
  func appLaunchLocations() -> AppLaunchLocationsModel
  func timeInAppManaged() -> TimeInApplicationModel
}
