import UIKit

class DataViewController: UIViewController {
  var links: [String: String]?
  var textTitle = ""
  var textDescription = ""
  let fontSize = 20

  @IBOutlet weak var pageTitle: UILabel!
  @IBOutlet weak var pageDescription: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  func configureView() {
    self.pageTitle.text = textTitle
    if let link = links {
      self.pageDescription.addHyperLinksToText(originalText: textDescription, hyperLinks: link, fontSize: fontSize)
    } else {
      self.pageDescription.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
      self.pageDescription.text = textDescription
    }
  }
}
