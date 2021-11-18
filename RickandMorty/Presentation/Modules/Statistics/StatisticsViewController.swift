import UIKit

class StatisticsViewController: UIViewController, StoryboardCreatable {
  var views: [UIView] = []

  @IBOutlet weak var viewContainer: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    self.navigationController?.isHiddenHairline = true

    let inAppTimeViewController = InAppTimeViewController.createFromStoryboard

    views.append(inAppTimeViewController.view)
    views.append(GoogleMapViewController().view)

    for myView in views {
      viewContainer.addSubview(myView)
    }

    let inAppTimeView: [String: Any] = ["inAppTimeView": views[0]]
    viewContainer.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[inAppTimeView]|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: inAppTimeView))

    viewContainer.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[inAppTimeView]|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: inAppTimeView))

    viewContainer.bringSubviewToFront(views[0])
  }

  @IBAction func switchViewAction(_ sender: UISegmentedControl) {
    self.viewContainer.bringSubviewToFront(views[sender.selectedSegmentIndex])
  }
}
