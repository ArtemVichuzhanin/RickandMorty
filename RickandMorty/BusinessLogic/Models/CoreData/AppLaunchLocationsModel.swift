import UIKit
import CoreData

struct AppLaunchLocationsModel {
  lazy var managedContext: NSManagedObjectContext = {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      let context = appDelegate.persistentContainer.viewContext
      return context
    } else {
      fatalError("AppDelegate is nil")
    }
  }()

  func saveLocation(latitude: Double, longitude: Double) {
    var mutatableSelf = self

    let entity = AppLaunchLocation(context: mutatableSelf.managedContext)
    entity.latitude = latitude
    entity.longitude = longitude

    do {
      try mutatableSelf.managedContext.save()
    } catch {
      mutatableSelf.managedContext.rollback()
      let nserror = error as NSError
      fatalError("Save failed unresolved error \(nserror), \(nserror.userInfo)")
    }
  }

  func loadLocations(completion: @escaping ([AppLaunchLocation]) -> Void) {
    var mutatableSelf = self

    let request = NSFetchRequest<AppLaunchLocation>(entityName: "AppLaunchLocation")
    do {
      completion(try mutatableSelf.managedContext.fetch(request))
    } catch let error as NSError {
      print("Load failed: \(error), \(error.userInfo)")
    }
  }
}
