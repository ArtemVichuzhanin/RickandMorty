import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var coordinator: AppCoordinatorProtocol?

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
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
  }
}
