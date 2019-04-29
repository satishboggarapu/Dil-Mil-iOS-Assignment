import UIKit
import SnapKit
import MaterialComponents
import SDWebImage

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
//    private var activityIndication: MDCActivityIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupView()
        addConstraints()

        albumImageView.sd_setImage(with: URL(string: "https://freemusicarchive.org/file/images/artists/the_tunnel_-_20150909203729678.jpg"), placeholderImage: nil)
    }

    override func addConstraints() {
        albumView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(view.bounds.height * 0.15)
            maker.centerX.equalToSuperview()
            maker.size.equalTo(view.bounds.width * 0.75)
        }

        albumImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }


        backButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.top.equalToSuperview().offset(statusBarHeight + 8)
            maker.size.equalTo(36)
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
            maker.width.equalTo(40)
            maker.height.equalTo(20)
        }

        trackTotalTime.snp.makeConstraints { maker in
            maker.right.equalTo(slider)
            maker.bottom.equalTo(slider.snp.top).inset(-3)
            maker.width.equalTo(40)
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
        backButton.setImage(UIImage(icon: .LEFT_ARROW), for: .normal)
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
//        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
//        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
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
    
    @objc private func backButtonAction() {

    }
    
    @objc private func playPauseButtonAction() {
        
    }

    @objc private func previousTrackButtonAction() {

    }

    @objc private func nextTrackButtonAction() {

    }
}