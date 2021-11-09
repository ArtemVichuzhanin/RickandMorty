import UIKit

class RootViewController: UIViewController {
  // MARK: Output
  var startFlow: (() -> Void)?
  var homeScreenFlow:(() -> Void)?

  let logoImageView: UIImageView = {
    let theImageView = UIImageView()

    theImageView.image = UIImage(named: "LaunchImage")
    theImageView.translatesAutoresizingMaskIntoConstraints = false

    return theImageView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .init(red: 254 / 255, green: 254 / 255, blue: 51 / 255, alpha: 1.0)
    self.view.addSubview(logoImageView)
    logoImageViewConstraints()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.didLogin.rawValue) {
      self.homeScreenFlow?()
    } else {
      self.startFlow?()
    }
  }

  func logoImageViewConstraints() {
    logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    logoImageView.heightAnchor.constraint(equalToConstant: 106).isActive = true
    logoImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
  }
}
