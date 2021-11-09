import UIKit

class WelcomeViewController: UIViewController, StoryboardCreatable {
  private var currentViewControllerIndex = 0
  private var pageList = WelcomePageModel()
  var onSkipTapped: (() -> Void)?
  @IBOutlet weak private var contentView: UIView!
  @IBOutlet weak private var pageControl: UIPageControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    loadPageTextFromJson()
    configurePageViewController()
    configurePageControl()
  }

  private func loadPageTextFromJson() {
    if let urlPath = Bundle.main.url(forResource: "About", withExtension: "json") {
      do {
        let data = try Data(contentsOf: urlPath)
        let pages = try JSONDecoder().decode([WelcomePage].self, from: data)
        pages.forEach { page in
          pageList.addPage(page)
        }
      } catch {
        print("Failed reading from URL: \(urlPath), Error: " + error.localizedDescription)
      }
    } else {
      print("About.json not found.")
    }
  }

  private func configurePageViewController() {
    guard let pageViewController = CustomPageViewController.createFromStoryboard as? CustomPageViewController
    else { return }

    pageViewController.delegate = self
    pageViewController.dataSource = self
    addChild(pageViewController)
    pageViewController.didMove(toParent: self)
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(pageViewController.view)

    guard let pageView = pageViewController.view else { return }

    let views: [String: Any] = ["pageView": pageView]
    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[pageView]|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: views))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[pageView]|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: views))

    guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else { return }
    pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
  }

  private func configurePageControl() {
    self.pageControl.pageIndicatorTintColor = UIColor(named: AppColorKeys.colorForInterface.rawValue)
    self.pageControl.currentPageIndicatorTintColor = UIColor(named: AppColorKeys.colorForInterface.rawValue)

    self.pageControl.numberOfPages = pageList.pages.count
    self.pageControl.currentPage = currentViewControllerIndex
    self.pageControl.isUserInteractionEnabled = false
    self.pageControl.backgroundStyle = .minimal
    updatePageControlUI(currentViewControllerIndex)
  }

  private func updatePageControlUI(_ currentPage: Int) {
    (0..<self.pageControl.numberOfPages).forEach { (index) in
      let activePageIconImage = UIImage(named: "current_page_dot")
      let otherPageIconImage = UIImage(named: "other_page_dot")
      let pageIcon = index == currentPage ? activePageIconImage : otherPageIconImage
      self.pageControl.setIndicatorImage(pageIcon, forPage: index)
    }
  }

  private func detailViewControllerAt(index: Int) -> DataViewController? {
    if index >= pageList.pages.count || pageList.pages.isEmpty {
      return nil
    }

    guard let dataViewController = DataViewController.createFromStoryboard as? DataViewController else { return nil }

    dataViewController.loadViewIfNeeded()
    dataViewController.configure(with: pageList.pages[index])
    dataViewController.view.tag = index
    return dataViewController
  }

  @IBAction private func buttonTappedAction() {
    self.dismiss(animated: true)
    self.onSkipTapped?()
  }
}

// MARK: - Extension UIPageViewController

extension WelcomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard var currentIndex = pageViewController.viewControllers?.first?.view.tag else { return nil }

    currentViewControllerIndex = currentIndex

    if currentIndex == 0 { return nil }

    currentIndex -= 1
    return detailViewControllerAt(index: currentIndex)
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard var currentIndex = pageViewController.viewControllers?.first?.view.tag else { return nil }

    if currentIndex == pageList.pages.count { return nil }

    currentIndex += 1
    currentViewControllerIndex = currentIndex
    return detailViewControllerAt(index: currentIndex)
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard completed else { return }

    guard let index = pageViewController.viewControllers?.first?.view.tag else { return }

    self.pageControl.currentPage = index
    updatePageControlUI(index)
  }
}
