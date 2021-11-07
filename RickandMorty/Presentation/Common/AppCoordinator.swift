import UIKit

protocol AppCoordinatorProtocol {
  func startFlow()
  func homeScreenFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
  private weak var rootController: UIViewController?

  init(viewController: UIViewController) {
    self.rootController = viewController
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func startFlow() {
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.notfirstStart.rawValue) {
      self.showLoginScreen()
    } else {
      UserDefaults.standard.set(true, forKey: UserDefaultsKeys.notfirstStart.rawValue)

      guard let welcomeVC = WelcomeViewController.createFromStoryboard as? WelcomeViewController else { return }

      welcomeVC.onSkipTapped = { [weak self] in
        self?.showLoginScreen()
      }
      self.rootController?.present(welcomeVC, animated: true, completion: nil)
    }
  }

    func homeScreenFlow() {
      self.showHomeScreen()
    }

    // MARK: - Private methods
    private func showLoginScreen() {
      self.rootController?.present(AuthViewController.createFromStoryboard, animated: true, completion: nil)
    }

    private func showHomeScreen() {
      self.rootController?.present(CustomTabBarViewController.createFromStoryboard, animated: true, completion: nil)
    }
}
