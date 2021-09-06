//
//  ViewController.swift
//  RickandMorty
//
//  Created by Артем  on 02.09.2021.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var contentView: UIView!
  var currentViewControllerIndex = 0
  let images = ["pic_one", "pic_two", "pic_three"]

  override func viewDidLoad() {
    super.viewDidLoad()
    configurePageViewController()
    setupPageControl()
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

  func setupPageControl() {
    let appearence = UIPageControl.appearance()
    appearence.pageIndicatorTintColor = .lightGray
    appearence.currentPageIndicatorTintColor = .darkGray
  }

  func detailViewControllerAt(index: Int) -> DataViewController? {
    if index >= images.count || images.isEmpty {
      return nil
    }
    guard let dataViewController = storyboard?.instantiateViewController(
    withIdentifier: String(describing: DataViewController.self)) as? DataViewController else { return nil }
    dataViewController.itemIndex = index
    dataViewController.imageName = images[index]
    return dataViewController
  }
}

extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return self.currentViewControllerIndex
  }
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return images.count
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let dataViewController = viewController as? DataViewController
    guard var currentIndex = dataViewController?.itemIndex else { return nil }
    currentViewControllerIndex = currentIndex
    if currentIndex == 0 { return nil }
    currentIndex -= 1
    return detailViewControllerAt(index: currentIndex)
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let dataViewController = viewController as? DataViewController
    guard var currentIndex = dataViewController?.itemIndex else { return nil }
    if currentIndex == images.count { return nil }
    currentIndex += 1
    currentViewControllerIndex = currentIndex
    return detailViewControllerAt(index: currentIndex)
  }
}
