import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        setupTabBarViewControllers()

    }

    private func setupTabBar() {
        tabBar.barTintColor = .white
        tabBar.barStyle = .default
        tabBar.isOpaque = false
        tabBar.isTranslucent = false
        tabBar.tintColor = .appColor
        tabBar.unselectedItemTintColor = UIColor(hex: 0xd2d3d2)
    }

    private func setupTabBarViewControllers() {
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(icon: .SEARCH), tag: 0)

        let browseViewController = BrowseViewController()
        browseViewController.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(icon: .LIBRARY), tag: 1)

        let nowPlayingViewController = NowPlayingViewController()
        nowPlayingViewController.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(icon: .NOW_PLAYING), tag: 2)

        let controllers = [browseViewController]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }
}