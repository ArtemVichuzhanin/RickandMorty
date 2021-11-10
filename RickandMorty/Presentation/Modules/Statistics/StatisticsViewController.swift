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

    views.append(InAppTimeViewController().view)
    views.append(GoogleMapViewController().view)

    for myView in views {
      viewContainer.addSubview(myView)
    }
    viewContainer.bringSubviewToFront(views[0])
  }

  @IBAction func switchViewAction(_ sender: UISegmentedControl) {
    self.viewContainer.bringSubviewToFront(views[sender.selectedSegmentIndex])
  }
}
