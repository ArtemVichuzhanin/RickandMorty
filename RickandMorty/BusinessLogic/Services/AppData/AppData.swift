import Foundation

class AppData: AppDataDelegate {
  static let shared = AppData()

  private init() {}

  public func appLaunchLocations() -> AppLaunchLocationsModel {
    let locations = AppLaunchLocationsModel()
    return locations
  }
}

extension AppData: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
