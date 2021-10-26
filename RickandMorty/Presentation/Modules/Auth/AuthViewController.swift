import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate, StoryboardCreatable {
  private let authService: AuthServiceProtocol = AuthService()
  @IBOutlet weak var login: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var secureButton: UIButton!
  var activeTextField: UITextField?


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupView()
    addKeyboardListeners()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }

  func addKeyboardListeners() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillDisappear),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillAppear),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
  }

  private func setupView() {
    self.login.addBottomBorder()
    self.password.addBottomBorder()
    self.secureButton.setTitle("", for: .normal)
    self.login.delegate = self
    self.password.delegate = self
  }

  @objc func keyboardWillAppear(sender: NSNotification) {
    guard let currentTextField = self.activeTextField else { return }
    if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if currentTextField.frame.origin.y > keyboardSize.origin.y {
        self.view.frame.origin.y = keyboardSize.origin.y - currentTextField.center.y - 20
      }
    }
  }

  @objc func keyboardWillDisappear() {
    self.view.frame.origin.y = 0
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.activeTextField = textField
    if self.login.textColor == UIColor.red {
      changeTextColor(color: UIColor.black)
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard
      let loginText = self.login.text,
      let passwordText = self.password.text
    else { return }
    if loginText.isEmpty || passwordText.isEmpty {
      self.loginButton.isEnabled = false
    } else {
      self.loginButton.isEnabled = true
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  private func showErrorAlert() {
    let alertTitle = "Error"
    let range = (alertTitle as NSString).range(of: alertTitle)
    let attribute = NSMutableAttributedString.init(string: alertTitle)
    attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
    let alert = UIAlertController(title: "", message: "Incorrect Login or Password", preferredStyle: .alert)
    alert.setValue(attribute, forKey: "attributedTitle")
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }

  private func changeTextColor(color: UIColor) {
    self.login.textColor = color
    self.password.textColor = color
  }

  @IBAction private func onSecureTextTapped() {
    self.password.togglePasswordVisibility()
  }

  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)

    coordinator.animate(alongsideTransition: nil) {_ in
      guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }

      if windowInterfaceOrientation.isLandscape {
        self.reDrawBottomBorder()
      } else {
        self.reDrawBottomBorder()
      }
    }
  }

  private func reDrawBottomBorder() {
    self.login.removeBottomBorder()
    self.password.removeBottomBorder()
    self.login.addBottomBorder()
    self.password.addBottomBorder()
  }

  private var windowInterfaceOrientation: UIInterfaceOrientation? {
    return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
  }

  @IBAction private func onLoginTapped() {
    guard
      let loginText = login.text,
      let passwordText = password.text
    else { return }
    if self.authService.logIn(login: loginText, password: passwordText) {
      self.present(HomeViewController.createFromStoryboard, animated: true, completion: nil)
    } else {
      showErrorAlert()
      changeTextColor(color: UIColor.red)
    }
  }
}
