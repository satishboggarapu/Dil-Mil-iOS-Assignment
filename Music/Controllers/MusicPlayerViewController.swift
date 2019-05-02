import UIKit
import SnapKit
import MaterialComponents
import SDWebImage
import AVFoundation

/*class MusicPlayerViewController: UIViewController {

    // MARK: UIElements
    private var albumImageView: UIImageView!
    private var blurView: UIView!
    private var backButton: UIButton!
    private var playPauseButton: UIButton!
    private var previousTrackButton: UIButton!
    private var nextTrackButton: UIButton!
    private var slider: MDCSlider!
    private var songNameLabel: UILabel!
    private var songInfoLabel: UILabel!
    private var trackCurrentTime: UILabel!
    private var trackTotalTime: UILabel!
    private var activityIndication: MDCActivityIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addConstraints()

        albumImageView.sd_setImage(with: URL(string: "https://freemusicarchive.org/file/images/artists/the_tunnel_-_20150909203729678.jpg"), placeholderImage: nil)
    }

    override func addConstraints() {
        albumImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        blurView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.top.equalToSuperview().offset(statusBarHeight + 8)
            maker.size.equalTo(36)
        }

        playPauseButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).inset(48)
            maker.size.equalTo(56)
        }

        previousTrackButton.snp.makeConstraints { maker in
            maker.right.equalTo(playPauseButton.snp.left).inset(-16)
            maker.centerY.equalTo(playPauseButton)
            maker.size.equalTo(48)
        }

        nextTrackButton.snp.makeConstraints { maker in
            maker.left.equalTo(playPauseButton.snp.right).offset(16)
            maker.centerY.equalTo(playPauseButton)
            maker.size.equalTo(48)
        }

        slider.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().inset(16)
            maker.bottom.equalTo(playPauseButton.snp.top).inset(-24)
            maker.height.equalTo(20)
        }

        songInfoLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().inset(16)
            maker.bottom.equalTo(slider.snp.top).inset(-16)
            maker.height.equalTo(24)
        }

        songNameLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().inset(16)
            maker.bottom.equalTo(songInfoLabel.snp.top).inset(-8)
            maker.height.equalTo(24)
        }

        trackCurrentTime.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.top.equalTo(slider.snp.bottom).offset(4)
            maker.width.equalTo(40)
            maker.height.equalTo(20)
        }

        trackTotalTime.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(24)
            maker.top.equalTo(slider.snp.bottom).offset(4)
            maker.width.equalTo(40)
            maker.height.equalTo(20)
        }
    }

    override func setupView() {
        albumImageView = UIImageView()
        albumImageView.contentMode = .scaleAspectFill
        view.addSubview(albumImageView)

        blurView = UIView()
        blurView.backgroundColor = UIColor(white: 0, alpha: 0.75)
        albumImageView.addSubview(blurView)

        backButton = UIButton()
        backButton.setImage(UIImage(icon: .LEFT_ARROW), for: .normal)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)

        playPauseButton = UIButton()
        playPauseButton.backgroundColor = .white
        playPauseButton.setImage(UIImage(icon: .PLAY_48), for: .normal)
        playPauseButton.setTitle(nil, for: .normal)
        playPauseButton.imageView?.tintColor = .black
        playPauseButton.addTarget(self, action: #selector(playPauseButtonAction), for: .touchUpInside)
        playPauseButton.layer.cornerRadius = 28
        view.addSubview(playPauseButton)

        previousTrackButton = UIButton()
        previousTrackButton.backgroundColor = .clear
        previousTrackButton.setImage(UIImage(icon: .PREVIOUS_TRACK_36), for: .normal)
        previousTrackButton.setTitle(nil, for: .normal)
        previousTrackButton.imageView?.tintColor = .white
        previousTrackButton.addTarget(self, action: #selector(previousTrackButtonAction), for: .touchUpInside)
        view.addSubview(previousTrackButton)

        nextTrackButton = UIButton()
        nextTrackButton.backgroundColor = .clear
        nextTrackButton.setImage(UIImage(icon: .NEXT_TRACK_36), for: .normal)
        nextTrackButton.setTitle(nil, for: .normal)
        nextTrackButton.imageView?.tintColor = .white
        nextTrackButton.addTarget(self, action: #selector(nextTrackButtonAction), for: .touchUpInside)
        view.addSubview(nextTrackButton)

        slider = MDCSlider()
        slider.color = .white
        slider.setThumbColor(.white, for: .normal)
        slider.trackBackgroundColor = .white
        slider.isThumbHollowAtStart = false
        slider.thumbRadius = 8
//        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
//        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        view.addSubview(slider)

        songNameLabel = UILabel()
        songNameLabel.text = "Song Name Label"
        songNameLabel.textColor = .white
        songNameLabel.textAlignment = .center
        songNameLabel.font = Font.Futura.bold(with: 18)
        view.addSubview(songNameLabel)

        songInfoLabel = UILabel()
        songInfoLabel.text = "Song Info Label"
        songInfoLabel.textColor = .white
        songInfoLabel.textAlignment = .center
        songInfoLabel.font = Font.Futura.medium(with: 18)
        view.addSubview(songInfoLabel)

        trackCurrentTime = UILabel()
        trackCurrentTime.text = "1:23"
        trackCurrentTime.textColor = .white
        trackCurrentTime.textAlignment = .left
        trackCurrentTime.font = Font.Futura.medium(with: 17)
        view.addSubview(trackCurrentTime)

        trackTotalTime = UILabel()
        trackTotalTime.text = "4:52"
        trackTotalTime.textColor = .white
        trackTotalTime.textAlignment = .right
        trackTotalTime.font = Font.Futura.medium(with: 17)
        view.addSubview(trackTotalTime)

    }

    @objc private func backButtonAction() {
        dismiss(animated: true)
    }

    @objc private func playPauseButtonAction() {

    }

    @objc private func previousTrackButtonAction() {

    }

    @objc private func nextTrackButtonAction() {

    }
}*/

class MusicPlayerViewController: UIViewController {

    // MARK: UIElements
    private var albumView: UIView!
    private var albumImageView: UIImageView!
    private var backButton: UIButton!
    private var songNameLabel: UILabel!
    private var songInfoLabel: UILabel!
    private var slider: UISlider!
    private var trackCurrentTime: UILabel!
    private var trackTotalTime: UILabel!
    private var playPauseButton: UIButton!
    private var previousTrackButton: UIButton!
    private var nextTrackButton: UIButton!

    private var player: Player!
    private var timer = Timer()
    private var isMovingSlider: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        player = Player.getInstance()
        setupView()
        addConstraints()

        refreshUI()

        NotificationCenter.default.addObserver(self, selector: #selector(trackReadyToPlay(_:)), name: .trackReadyToPlay, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(trackLoading(_:)), name: .trackLoading, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let interval = CMTime(value: 1, timescale: 1)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSliderValue), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: .trackReadyToPlay, object: nil)
        NotificationCenter.default.removeObserver(self, name: .trackLoading, object: nil)
    }

    override func addConstraints() {
        albumView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(view.bounds.height * 0.15)
            maker.centerX.equalToSuperview()
            maker.size.equalTo(view.bounds.width * 0.85)
        }

        albumImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.top.equalToSuperview().offset(statusBarHeight + 8)
            maker.size.equalTo(48)
        }

        songNameLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.right.equalToSuperview().inset(24)
            maker.top.equalTo(albumView.snp.bottom).offset(48)
            maker.height.equalTo(32)
        }

        songInfoLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.right.equalToSuperview().inset(24)
            maker.top.equalTo(songNameLabel.snp.bottom).offset(4)
            maker.height.equalTo(24)
        }

        slider.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(36)
            maker.right.equalToSuperview().inset(36)
            maker.top.equalTo(songInfoLabel.snp.bottom).offset(36)
            maker.height.equalTo(20)
        }

        playPauseButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(slider.snp.bottom).offset(36)
            maker.size.equalTo(56)
        }

        previousTrackButton.snp.makeConstraints { maker in
            maker.right.equalTo(playPauseButton.snp.left).inset(-24)
            maker.centerY.equalTo(playPauseButton)
            maker.size.equalTo(52)
        }

        nextTrackButton.snp.makeConstraints { maker in
            maker.left.equalTo(playPauseButton.snp.right).offset(24)
            maker.centerY.equalTo(playPauseButton)
            maker.size.equalTo(52)
        }

        trackCurrentTime.snp.makeConstraints { maker in
            maker.left.equalTo(slider)
            maker.bottom.equalTo(slider.snp.top).inset(-3)
            maker.width.equalTo(55)
            maker.height.equalTo(20)
        }

        trackTotalTime.snp.makeConstraints { maker in
            maker.right.equalTo(slider)
            maker.bottom.equalTo(slider.snp.top).inset(-3)
            maker.width.equalTo(55)
            maker.height.equalTo(20)
        }
    }

    override func setupView() {
        albumView = UIView()
        albumView.backgroundColor = .white
        albumView.layer.cornerRadius = 16
        albumView.layer.shadowOffset = .zero
        albumView.layer.shadowColor = UIColor.gray.cgColor
        albumView.layer.shadowRadius = 16
        albumView.layer.shadowOpacity = 0.75
        view.addSubview(albumView)

        albumImageView = UIImageView()
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 16
        albumImageView.clipsToBounds = true
        albumView.addSubview(albumImageView)

        backButton = UIButton()
        backButton.setImage(UIImage(icon: .DOWN_ARROW), for: .normal)
        backButton.imageView?.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)

        songNameLabel = UILabel()
        songNameLabel.text = "Song Name Label"
        songNameLabel.textColor = .black
        songNameLabel.textAlignment = .center
        songNameLabel.font = Font.Futura.medium(with: 24)
        view.addSubview(songNameLabel)

        songInfoLabel = UILabel()
        songInfoLabel.text = "Song Info Label"
        songInfoLabel.textColor = .black
        songInfoLabel.textAlignment = .center
        songInfoLabel.font = Font.Futura.regular(with: 18)
        view.addSubview(songInfoLabel)

        slider = UISlider()
        slider.maximumTrackTintColor = UIColor(hex: 0xe5e5e5)
        slider.minimumTrackTintColor = .black
        slider.setThumbImage(UIImage(), for: .normal)
        slider.setValue(0.45, animated: false)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        view.addSubview(slider)

        playPauseButton = UIButton()
        playPauseButton.setImage(UIImage(icon: .PLAY_48), for: .normal)
        playPauseButton.setTitle(nil, for: .normal)
        playPauseButton.imageView?.tintColor = .black
        playPauseButton.addTarget(self, action: #selector(playPauseButtonAction), for: .touchUpInside)
        view.addSubview(playPauseButton)

        previousTrackButton = UIButton()
        previousTrackButton.setImage(UIImage(icon: .PREVIOUS_TRACK_36), for: .normal)
        previousTrackButton.setTitle(nil, for: .normal)
        previousTrackButton.imageView?.tintColor = .black
        previousTrackButton.addTarget(self, action: #selector(previousTrackButtonAction), for: .touchUpInside)
        view.addSubview(previousTrackButton)

        nextTrackButton = UIButton()
        nextTrackButton.setImage(UIImage(icon: .NEXT_TRACK_36), for: .normal)
        nextTrackButton.setTitle(nil, for: .normal)
        nextTrackButton.imageView?.tintColor = .black
        nextTrackButton.addTarget(self, action: #selector(nextTrackButtonAction), for: .touchUpInside)
        view.addSubview(nextTrackButton)

        trackCurrentTime = UILabel()
        trackCurrentTime.text = "1:23"
        trackCurrentTime.textColor = .black
        trackCurrentTime.textAlignment = .left
        trackCurrentTime.font = Font.Futura.medium(with: 17)
        view.addSubview(trackCurrentTime)

        trackTotalTime = UILabel()
        trackTotalTime.text = "4:52"
        trackTotalTime.textColor = .black
        trackTotalTime.textAlignment = .right
        trackTotalTime.font = Font.Futura.medium(with: 17)
        view.addSubview(trackTotalTime)

    }

    private func refreshUI() {
        DispatchQueue.main.async {
            let image = self.player.isTrackPaused() ? UIImage(icon: .PLAY_36) : UIImage(icon: .PAUSE_36)
            self.playPauseButton.setImage(image, for: .normal)

            self.updateSliderValue(override: true)

            if let track = self.player.getCurrentTrack() {
                self.albumImageView.sd_setImage(with: URL(string: track.trackImageUrl!))
                self.songNameLabel.text = track.title
                self.songInfoLabel.text = track.albumTitle
                self.trackTotalTime.text = track.trackDuration
            }
        }
    }

    @objc private func sliderDidEndSliding() {
        if let playerItem = player.getAudioPlayerCurrentItem() {
            let totalSeconds = CMTimeGetSeconds(playerItem.asset.duration)
            let value = Float64(slider.value) * totalSeconds
            if !value.isNaN {
                let seekTime = CMTime(value: Int64(value), timescale: 1)
                player.seekAudioPlayerTo(time: seekTime) {
                    self.isMovingSlider = false
                    self.updateSliderValue(override: true)
                }
            }
        }
    }

    @objc private func sliderValueChanged() {
        isMovingSlider = true
    }

    @objc func updateSliderValue(override: Bool) {
        if !isMovingSlider && !player.isTrackPaused() || override {
            slider.value = player.getSliderValue()
            trackCurrentTime.text = player.getTrackCurrentTime()
        }
    }
    
    @objc private func backButtonAction() {
        self.dismiss(animated: true)
    }
    
    @objc private func playPauseButtonAction() {
        player.togglePlayPauseState()
        refreshUI()
    }

    @objc private func previousTrackButtonAction() {
        player.previousTrack()
//        refreshUI()
    }

    @objc private func nextTrackButtonAction() {
        player.nextTrack()
//        refreshUI()
    }
    
    @objc private func trackReadyToPlay(_ notification: Notification) {
        // TODO: End animation
        print("stop animation - mvc")
        refreshUI()
    }

    @objc private func trackLoading(_ notification: Notification) {
        // TODO Animation start
        print("Start animation - mvc")
        refreshUI()
    }
}
