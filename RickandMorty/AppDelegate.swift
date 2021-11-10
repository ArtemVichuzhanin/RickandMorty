import UIKit
import CoreData
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
  private let appLaunchLocation = AppData.shared.appLaunchLocations()
  private let locationManager = CLLocationManager()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    CustomNotifications.shared.requestAuth()

    GMSServices.provideAPIKey("AIzaSyDXx0Bg67FeUIORpjs_L8DONsv3AGUxjrA")

    getLocation()

    return true
  }

  // MARK: CoreData

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "RickAndMortyCoreDataModel")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        context.rollback()
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  // MARK: CLLocationManager

  private func getLocation() {
    guard CLLocationManager.locationServicesEnabled() else {
      print("Location services disabled")
      return
    }

    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.last?.coordinate as CLLocationCoordinate2D? else { return }

    self.appLaunchLocation.saveLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

    manager.stopUpdatingLocation()
  }
}
