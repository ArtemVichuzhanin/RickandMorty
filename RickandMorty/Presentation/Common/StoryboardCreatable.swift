import UIKit

public protocol StoryboardCreatable: AnyObject {
  static var createFromStoryboard: UIViewController { get }
}

extension StoryboardCreatable {
  public static var createFromStoryboard: UIViewController {
    guard let controller = UIStoryboard(
      name: String(describing: Self.self),
      bundle: nil)
      .instantiateInitialViewController()
    else { fatalError("Not correct storyboard") }
    return controller
  }
}
