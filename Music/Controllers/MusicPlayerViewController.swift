import UIKit
import SnapKit
import MaterialComponents
import SDWebImage

class MusicPlayerViewController: UIViewController {

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
        blurView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        albumImageView.addSubview(blurView)

        backButton = UIButton()
        backButton.setImage(UIImage(icon: .LEFT_ARROW), for: .normal)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)

        playPauseButton = UIButton()
        playPauseButton.backgroundColor = .appColor
        playPauseButton.setImage(UIImage(icon: .PLAY_48), for: .normal)
        playPauseButton.setTitle(nil, for: .normal)
        playPauseButton.imageView?.tintColor = .white
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
        slider.color = .appColor
        slider.setThumbColor(.appColor, for: .normal)
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

    }
    
    @objc private func playPauseButtonAction() {
        
    }

    @objc private func previousTrackButtonAction() {

    }

    @objc private func nextTrackButtonAction() {

    }
}