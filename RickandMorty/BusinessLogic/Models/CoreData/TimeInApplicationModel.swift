import UIKit
import CoreData

struct TimeInApplicationModel {
  let dayInSeconds = Int32(86400)

  lazy var managedContext: NSManagedObjectContext = {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      let context = appDelegate.persistentContainer.viewContext
      return context
    } else {
      fatalError("AppDelegate is nil")
    }
  }()

  var fetchResult: [InAppTime]?
  var fetchResultCount: Int {
    return fetchResult?.count ?? 0
  }

  func saveTimeInApp() {
    var mutatableSelf = self

    loadTimeInApp { appTime in
      mutatableSelf.fetchResult = appTime
    }

    if mutatableSelf.fetchResultCount > 0 {
      guard let entityTimeApp = mutatableSelf.fetchResult?[0] else { return }

      let timeIntervalSinceLaunchApp = -Int32(round(entityTimeApp.launchTime?.timeIntervalSinceNow ?? 0))

      if (entityTimeApp.timeInApp + timeIntervalSinceLaunchApp) >= dayInSeconds {
        entityTimeApp.timeInApp += timeIntervalSinceLaunchApp - dayInSeconds
      } else {
        entityTimeApp.timeInApp += timeIntervalSinceLaunchApp
      }
    } else {
      fatalError("Not created InAppTime entity")
    }

    saveContext()
  }

  func saveLaunchTime() {
    var mutatableSelf = self

    loadTimeInApp { appTime in
      mutatableSelf.fetchResult = appTime
    }

    if mutatableSelf.fetchResultCount > 0 {
      guard let entityTimeApp = mutatableSelf.fetchResult?[0] else { return }

      entityTimeApp.launchTime = Date()
      mutatableSelf.saveTimeInApp()
    } else {
      let entity = InAppTime(context: mutatableSelf.managedContext)

      entity.launchTime = Date()
      entity.timeInApp = 0
    }

    saveContext()
  }

  func loadTimeInApp(completion: @escaping ([InAppTime]) -> Void) {
    var mutatableSelf = self

    let request = NSFetchRequest<InAppTime>(entityName: "InAppTime")
    do {
      completion(try mutatableSelf.managedContext.fetch(request))
    } catch let error as NSError {
      print("Load failed: \(error), \(error.userInfo)")
    }
  }

  func resetTimeInApp() {
    var mutatableSelf = self

    loadTimeInApp { appTime in
      mutatableSelf.fetchResult = appTime
    }

    if mutatableSelf.fetchResultCount > 0 {
      guard let entityTimeApp = mutatableSelf.fetchResult?[0] else { return }

      entityTimeApp.launchTime = Date()
      entityTimeApp.timeInApp = Int32(0)

      saveContext()
    }
  }

  func getTimeInApp() -> Int {
    var mutatableSelf = self

    loadTimeInApp { appTime in
      mutatableSelf.fetchResult = appTime
    }

    if mutatableSelf.fetchResultCount > 0 {
      guard let entityTimeApp = mutatableSelf.fetchResult?[0] else { return 0 }

      let timeIntervalSinceLaunchApp = -Int32(round(entityTimeApp.launchTime?.timeIntervalSinceNow ?? 0))

      if (entityTimeApp.timeInApp + timeIntervalSinceLaunchApp) >= dayInSeconds {
        return Int(entityTimeApp.timeInApp + timeIntervalSinceLaunchApp - dayInSeconds)
      } else {
        return Int(entityTimeApp.timeInApp + timeIntervalSinceLaunchApp)
      }
    } else {
      print("Not created InAppTime entity")
      return 0
    }
  }

  func saveContext() {
    var mutatableSelf = self

    if mutatableSelf.managedContext.hasChanges {
      do {
        try mutatableSelf.managedContext.save()
      } catch {
        mutatableSelf.managedContext.rollback()
        let nserror = error as NSError
        fatalError("Save failed unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
