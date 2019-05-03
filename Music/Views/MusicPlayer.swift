import UIKit
import SnapKit
import SDWebImage
import Lottie

class MusicPlayer: UIView {

    var albumView: UIView!
    var albumImageView: UIImageView!
    var titleLabel: UILabel!
    var nextTrackButton: UIButton!
    var playPauseButton: UIButton!
    var favoriteButton: UIButton!
    internal var loadingAnimationView: LOTAnimationView!

    private var player: Player!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.15

        player = Player.getInstance()
        setupView()

        NotificationCenter.default.addObserver(self, selector: #selector(newTrackStartedPlaying(_:)), name: .newTrackSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(trackLoading(_:)), name: .trackLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(trackReadyToPlay(_:)), name: .trackReadyToPlay, object: nil)

//        albumImageView.sd_setImage(with: URL(string: "https://freemusicarchive.org/file/images/artists/the_tunnel_-_20150909203729678.jpg"), placeholderImage: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        albumView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.top.equalToSuperview().offset(8)
            maker.bottom.equalToSuperview().inset(8)
            maker.width.equalTo(self.bounds.height-16)
        }

        albumImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        nextTrackButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(16)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(48)
        }

        playPauseButton.snp.makeConstraints { maker in
            maker.right.equalTo(nextTrackButton.snp.left).inset(-8)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(48)
        }

        favoriteButton.snp.makeConstraints { maker in
            maker.right.equalTo(playPauseButton.snp.left).inset(-8)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(32)
            maker.width.equalTo(0)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(albumView.snp.right).offset(24)
            maker.right.equalTo(favoriteButton.snp.left)
            maker.top.equalTo(albumView)
            maker.bottom.equalTo(albumView)
        }

        loadingAnimationView.snp.makeConstraints { maker in
            maker.edges.equalTo(playPauseButton)
        }

        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        albumView.layer.shadowPath = UIBezierPath(rect: albumView.bounds).cgPath
    }

    override func setupView() {
        albumView = UIView()
        albumView.backgroundColor = .white
        albumView.layer.cornerRadius = 4
        albumView.layer.shadowOffset = .zero
        albumView.layer.shadowColor = UIColor.gray.cgColor
        albumView.layer.shadowRadius = 4
        albumView.layer.shadowOpacity = 0.75
        addSubview(albumView)

        albumImageView = UIImageView()
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 4
        albumImageView.clipsToBounds = true
        albumView.addSubview(albumImageView)

        titleLabel = UILabel()
        titleLabel.text = "Title Label"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = Font.Futura.regular(with: 18)
        addSubview(titleLabel)

        nextTrackButton = UIButton()
        nextTrackButton.setImage(UIImage(icon: .NEXT_TRACK_36), for: .normal)
        nextTrackButton.imageView?.tintColor = .black
        nextTrackButton.imageView?.contentMode = .scaleAspectFit
        nextTrackButton.addTarget(self, action: #selector(nextTrackButtonAction), for: .touchUpInside)
        addSubview(nextTrackButton)

        playPauseButton = UIButton()
        playPauseButton.setImage(UIImage(icon: .PAUSE_36), for: .normal)
        playPauseButton.imageView?.tintColor = .black
        playPauseButton.imageView?.contentMode = .scaleAspectFit
        playPauseButton.addTarget(self, action: #selector(playPauseButtonAction), for: .touchUpInside)
        addSubview(playPauseButton)

        favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(icon: .HEART_OUTLINE_36), for: .normal)
        favoriteButton.imageView?.tintColor = .black
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        addSubview(favoriteButton)

        loadingAnimationView = LOTAnimationView(name: LottieAnimation.infinite_loading)
        loadingAnimationView.backgroundColor = .clear
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.loopAnimation = true
        loadingAnimationView.isHidden = true
        insertSubview(loadingAnimationView, aboveSubview: playPauseButton)
    }
    
    @objc private func playPauseButtonAction() {
        player.togglePlayPauseState()
        let image = player.isTrackPaused() ? UIImage(icon: .PLAY_36) : UIImage(icon: .PAUSE_36)
        playPauseButton.setImage(image, for: .normal)
    }
    
    @objc private func nextTrackButtonAction() {
        player.nextTrack()
    }

    @objc private func newTrackStartedPlaying(_ notification: Notification) {
        refreshView()
    }

    @objc private func trackLoading(_ notification: Notification) {
        loadingAnimationView.startAnimation()
        refreshView()
    }

    @objc private func trackReadyToPlay(_ notification: Notification) {
        loadingAnimationView.stopAnimation()
        refreshView()
    }

    func refreshView() {
        DispatchQueue.main.async {
            if let track = self.player.getCurrentTrack() {
                self.albumImageView.sd_setImage(with: URL(string: track.trackImageUrl!))
                self.titleLabel.text = track.title
            }

            let image = self.player.isTrackPaused() ? UIImage(icon: .PLAY_36) : UIImage(icon: .PAUSE_36)
            self.playPauseButton.setImage(image, for: .normal)
        }
    }
}