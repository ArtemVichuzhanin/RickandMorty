import UIKit

extension UITextField {
  func addBottomBorder() {
    let bottomLine = UIView()
    bottomLine.tag = 44
    bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 0.5)
    bottomLine.backgroundColor = UIColor.lightGray
    borderStyle = .none
    self.addSubview(bottomLine)
  }

  func removeBottomBorder() {
    self.subviews.forEach {
      if $0.tag == 44 {
        $0.removeFromSuperview()
      }
    }
  }

  func togglePasswordVisibility() {
    if let existingSelectedTextRange = selectedTextRange {
      selectedTextRange = nil
      selectedTextRange = existingSelectedTextRange
    }

    isSecureTextEntry.toggle()

    if let existingText = text, isSecureTextEntry {
      text = nil
      text = existingText
    }
  }

  @IBInspectable public var leftSpacer: CGFloat {
    get {
      return leftView?.frame.size.width ?? 0
    } set {
      leftViewMode = .always
      leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
    }
  }

  @IBInspectable public var rightSpacer: CGFloat {
    get {
      return rightView?.frame.size.width ?? 0
    } set {
      rightViewMode = .always
      rightView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
    }
  }
}
