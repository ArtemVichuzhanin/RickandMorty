import UIKit
import CoreData

struct AppLaunchLocationsModel {
  func saveLocation(latitude: Double, longitude: Double) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext

    let entity = AppLaunchLocation(context: context)
    entity.latitude = latitude
    entity.longitude = longitude
    do {
      try context.save()
    } catch let error as NSError {
      print("Save failed: \(error), \(error.userInfo)")
    }
  }

  func loadLocations(completion: @escaping ([AppLaunchLocation]) -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext

    let request = NSFetchRequest<AppLaunchLocation>(entityName: "AppLaunchLocation")
    do {
      completion(try context.fetch(request))
    } catch let error as NSError {
      print("Load failed: \(error), \(error.userInfo)")
    }
  }
}
