import UIKit

@IBDesignable
class CustomTabBar: UITabBar {
  private var shapeLayer: CALayer?

  private var safeAreaBottomInsets: CGFloat {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .first { $0 is UIWindowScene }
      .flatMap { $0 as? UIWindowScene }?.keyWindow?.safeAreaInsets.bottom ?? 0
  }

  override func draw(_ rect: CGRect) {
    drawTabBar()
  }

  private func drawTabBar() {
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = createPath()
    shapeLayer.fillColor = UIColor(named: AppColorKeys.colorForInterface.rawValue)?.cgColor

    if let oldShapeLayer = self.shapeLayer {
      self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
    } else {
      self.layer.insertSublayer(shapeLayer, at: 0)
    }
    self.shapeLayer = shapeLayer
  }

  private func createPath() -> CGPath {
    let tabBarWidth = self.frame.width
    let tabBarHeight = self.frame.height - safeAreaBottomInsets
    let centerWidth = self.frame.width / 2
    let radius: CGFloat = 36
    let path = UIBezierPath()

    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: centerWidth - radius, y: 0))
    path.addArc(
      withCenter: CGPoint(x: centerWidth, y: -6),
      radius: radius,
      startAngle: (9 * .pi) / 10,
      endAngle: .pi / 10,
      clockwise: false)
    path.addLine(to: CGPoint(x: centerWidth + radius, y: 0))
    path.addLine(to: CGPoint(x: tabBarWidth, y: 0))
    path.addLine(to: CGPoint(x: tabBarWidth, y: tabBarHeight))
    path.addLine(to: CGPoint(x: 0, y: tabBarHeight))
    path.close()

    return path.cgPath
  }

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let pointIsInside = super.point(inside: point, with: event)
    if pointIsInside == false {
      for subview in subviews {
        let pointInSubview = subview.convert(point, from: self)
        if subview.point(inside: pointInSubview, with: event) {
          return true
        }
      }
    }
    return pointIsInside
  }
}
