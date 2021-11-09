import UIKit

class DataViewController: UIViewController, StoryboardCreatable {
  private let fontSize = 20

  @IBOutlet weak var pageTitle: UILabel!
  @IBOutlet weak var pageDescription: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure(with: .none)
  }

  func configure(with page: WelcomePage?) {
    if let page = page {
      self.pageTitle.text = page.topic

      if let links = page.links {
        self.pageDescription.addHyperLinksToText(originalText: page.description, hyperLinks: links, fontSize: fontSize)
      } else {
        self.pageDescription.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        self.pageDescription.text = page.description
      }
    } else {
      self.pageTitle.text = ""
      self.pageDescription.text = ""
    }
  }
}
