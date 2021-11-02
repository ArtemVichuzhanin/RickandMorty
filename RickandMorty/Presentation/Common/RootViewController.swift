import UIKit

class RootViewController: UIViewController {
  // MARK: Output
  var startFlow: (() -> Void)?
  var homeScreenFlow:(() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .init(red: 254 / 255, green: 254 / 255, blue: 51 / 255, alpha: 1.0)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.didLogin.rawValue) {
      self.homeScreenFlow?()
    } else {
      self.startFlow?()
    }
  }
}
