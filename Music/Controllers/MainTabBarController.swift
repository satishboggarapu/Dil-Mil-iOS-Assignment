import UIKit
import SnapKit

class MainTabBarController: UITabBarController {

    var musicPlayer: MusicPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        setupTabBarViewControllers()
        setupView()
        addConstraints()

    }

/*    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        musicPlayerTapGesture()
    }*/

    override func addConstraints() {
        musicPlayer.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(tabBar.snp.top)
            maker.height.equalTo(54)
        }
    }

    private func setupTabBar() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .appColor
        tabBar.unselectedItemTintColor = UIColor(hex: 0xd2d3d2)
    }

    override func setupView() {
        musicPlayer = MusicPlayer()
        view.addSubview(musicPlayer)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(musicPlayerTapGesture))
        tapGesture.numberOfTapsRequired = 1
        musicPlayer.addGestureRecognizer(tapGesture)
    }

    private func setupTabBarViewControllers() {
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(icon: .SEARCH), tag: 0)

        let browseViewController = BrowseViewController()
        browseViewController.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(icon: .LIBRARY), tag: 1)

        let nowPlayingViewController = NowPlayingViewController()
        nowPlayingViewController.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(icon: .NOW_PLAYING), tag: 2)

        let musicPlayerViewController = MusicPlayerViewController()
        musicPlayerViewController.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(icon: .NOW_PLAYING), tag: 2)

        let controllers = [browseViewController, musicPlayerViewController]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }

    @objc private func musicPlayerTapGesture() {
        print("musicPlayer tap gesture")
        let musicPlayerViewController = MusicPlayerViewController()
        musicPlayerViewController.hidesBottomBarWhenPushed = true
        musicPlayerViewController.modalPresentationStyle = .overFullScreen
        present(musicPlayerViewController, animated: true)
    }
}