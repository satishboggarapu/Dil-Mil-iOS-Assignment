import UIKit
import SnapKit

class MainTabBarController: UITabBarController {

    var musicPlayer: MusicPlayer!
    var player: Player!

    override func viewDidLoad() {
        super.viewDidLoad()

        player = Player.getInstance()
        setupTabBar()
        setupTabBarViewControllers()
        setupView()
        addConstraints()

        NotificationCenter.default.addObserver(self, selector: #selector(newTrackSelected(_:)), name: .newTrackSelected, object: nil)
        toggleMusicPlayer()
    }

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
        let browseViewController = BrowseViewController()
        browseViewController.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(icon: .LIBRARY), tag: 0)

        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(icon: .SEARCH), tag: 1)

//        let accountViewController = AccountViewController()
//        accountViewController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(icon: .), tag: <#T##Int##Swift.Int#>)

        let controllers = [browseViewController, searchViewController]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }

    @objc private func musicPlayerTapGesture() {
        let musicPlayerViewController = MusicPlayerViewController()
        musicPlayerViewController.hidesBottomBarWhenPushed = true
        musicPlayerViewController.modalPresentationStyle = .overFullScreen
        present(musicPlayerViewController, animated: true)
    }

    @objc private func newTrackSelected(_ notification: Notification) {
        toggleMusicPlayer()
    }

    private func toggleMusicPlayer() {
        musicPlayer.isHidden = player.getCurrentTrackIndex() == nil
    }
}