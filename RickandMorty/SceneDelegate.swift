import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var coordinator: AppCoordinatorProtocol?
  let customNotifications = CustomNotifications.shared
  let timeInAppService = AppData.shared.timeInAppManaged()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window?.windowScene = windowScene

    let rootVC = RootViewController()
    self.window?.rootViewController = rootVC

    coordinator = AppCoordinator(viewController: rootVC)
    rootVC.startFlow = { [weak self] in
      self?.coordinator?.startFlow()
    }
    rootVC.homeScreenFlow = { [weak self] in
      self?.coordinator?.homeScreenFlow()
    }

    self.window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
  }

  func sceneWillResignActive(_ scene: UIScene) {
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    customNotifications.resetBadgeCount()

    timeInAppService.saveLaunchTime()
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    customNotifications.sendNotification(with: 2)

    timeInAppService.saveTimeInApp()
  }
}
