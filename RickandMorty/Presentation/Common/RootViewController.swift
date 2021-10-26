import UIKit

class RootViewController: UIViewController {
  // MARK: Output
  var startFlow: (() -> Void)?
  var homeScreenFlow:(() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.view.backgroundColor = .init(red: 254, green: 254, blue: 51, alpha: 1)
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.didLogin.rawValue) {
      self.homeScreenFlow?()
    } else {
      self.startFlow?()
    }
  }
}
