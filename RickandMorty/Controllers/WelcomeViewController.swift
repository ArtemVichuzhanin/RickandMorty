//
//  ViewController.swift
//  RickandMorty
//
//  Created by Артем  on 02.09.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var pageControl: UIPageControl!
  var currentViewControllerIndex = 0
  let images = ["pic_one", "pic_two", "pic_three"]

  override func viewDidLoad() {
    super.viewDidLoad()
    configurePageViewController()
    configurePageControl()
  }

  func configurePageViewController() {
    guard let pageViewController = storyboard?.instantiateViewController(
      withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else { return }
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

  func configurePageControl() {
    self.pageControl.pageIndicatorTintColor = .init(red: 0, green: 142, blue: 214, alpha: 1)
    self.pageControl.currentPageIndicatorTintColor = .init(red: 0, green: 142, blue: 214, alpha: 1)
    self.pageControl.numberOfPages = images.count
    self.pageControl.currentPage = currentViewControllerIndex
    updatePageControl(currentViewControllerIndex)
  }

  func updatePageControl(_ currentPage: Int) {
    (0..<self.pageControl.numberOfPages).forEach { (index) in
      let activePageIconImage = UIImage(named: "current_page_dot")
      let otherPageIconImage = UIImage(named: "other_page_dot")
      let pageIcon = index == currentPage ? activePageIconImage : otherPageIconImage
      self.pageControl.setIndicatorImage(pageIcon, forPage: index)
    }
  }

  func detailViewControllerAt(index: Int) -> DataViewController? {
    if index >= images.count || images.isEmpty {
      return nil
    }
    guard let dataViewController = storyboard?.instantiateViewController(
    withIdentifier: String(describing: DataViewController.self)) as? DataViewController else { return nil }
    dataViewController.imageName = images[index]
    dataViewController.view.tag = index
    return dataViewController
  }
}

// MARK: - Extension UIPageViewController Delegate and DataSource

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
    if currentIndex == images.count { return nil }
    currentIndex += 1
    currentViewControllerIndex = currentIndex
    return detailViewControllerAt(index: currentIndex)
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard completed else { return }
    guard let index = pageViewController.viewControllers?.first?.view.tag else { return }
    self.pageControl.currentPage = index
    updatePageControl(index)
  }
}
