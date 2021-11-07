import UIKit

class CustomTabBarViewController: UITabBarController, StoryboardCreatable {
  private let favoritesButtonSize: CGFloat = 56
  private var favoritesButton = UIButton(type: .custom) as UIButton

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    delegate = self
  }

  private func setupView() {
    guard let appearance = self.tabBar.scrollEdgeAppearance else { return }

    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11)
    ]
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    self.tabBar.scrollEdgeAppearance = appearance

    let charactersViewController = CharactersTableViewController.createFromStoryboard
    let locationsViewController = LocationsViewController.createFromStoryboard
    let favoritesViewController = FavoritesViewController.createFromStoryboard
    let statisticsViewController = StatisticsViewController.createFromStoryboard
    let episodesViewController = EpisodesViewController.createFromStoryboard

    viewControllers = [
      charactersViewController,
      locationsViewController,
      favoritesViewController,
      statisticsViewController,
      episodesViewController
    ]

    self.tabBar.items?[2].isEnabled = false
    setupFavoritesButton()
  }

  private func setupFavoritesButton() {
    var favoritesButtonConfiguration = UIButton.Configuration.filled()

    favoritesButtonConfiguration.background.cornerRadius = favoritesButtonSize / 2
    favoritesButtonConfiguration.baseBackgroundColor = UIColor(named: AppColorKeys.colorForInterface.rawValue)
    favoritesButtonConfiguration.baseForegroundColor = .white
    favoritesButtonConfiguration.image = UIImage(systemName: "heart.fill")

    favoritesButton.configuration = favoritesButtonConfiguration
    favoritesButton.translatesAutoresizingMaskIntoConstraints = false
    favoritesButton.addTarget(self, action: #selector(onFavoritesTapped(sender:)), for: .touchUpInside)

    self.tabBar.addSubview(favoritesButton)
    NSLayoutConstraint.activate([
      favoritesButton.heightAnchor.constraint(equalToConstant: favoritesButtonSize),
      favoritesButton.widthAnchor.constraint(equalToConstant: favoritesButtonSize),
      favoritesButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
      favoritesButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -35)
    ])
  }

  @objc private func onFavoritesTapped(sender: UIButton) {
    selectedIndex = 2
    sender.configuration?.baseForegroundColor = UIColor(named: AppColorKeys.colorForSelectedItem.rawValue)
    }
}

// MARK: - Extension UITabBarController

extension CustomTabBarViewController: UITabBarControllerDelegate {
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if self.tabBar.selectedItem?.tag != 2 {
      favoritesButton.configuration?.baseForegroundColor = .white
    }
  }
}
