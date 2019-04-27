import UIKit
import SnapKit

class MusicPlayer: UIView {

    var titleLabel: UILabel!
    var subTitleLabel: UILabel!
    var favoriteButton: UIButton!
    var playPauseButton: UIButton!
    var slider: UISlider!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .gray
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        favoriteButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(8)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(self.snp.height)
        }

        playPauseButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(8)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(self.snp.height)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(favoriteButton.snp.right).offset(16)
            maker.right.equalTo(playPauseButton.snp.left).inset(-16)
            maker.top.equalToSuperview().offset(6)
            maker.bottom.equalTo(self.snp.centerY)
        }

        subTitleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(favoriteButton.snp.right).offset(16)
            maker.right.equalTo(playPauseButton.snp.left).inset(-16)
            maker.bottom.equalToSuperview().inset(8)
            maker.top.equalTo(self.snp.centerY)
        }

        slider.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(2)
        }

    }

    override func setupView() {
        titleLabel = UILabel()
        titleLabel.text = "Title Label"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = Font.Futura.medium(with: 15)
        addSubview(titleLabel)

        subTitleLabel = UILabel()
        subTitleLabel.text = "Sub title label"
        subTitleLabel.textColor = .black
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = Font.Futura.regular(with: 15)
        addSubview(subTitleLabel)

        favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(icon: .HEART_OUTLINE_36), for: .normal)
        favoriteButton.imageView?.tintColor = .black
        addSubview(favoriteButton)

        playPauseButton = UIButton()
        playPauseButton.setImage(UIImage(icon: .PLAY_36), for: .normal)
        playPauseButton.imageView?.tintColor = .black
        addSubview(playPauseButton)

        slider = UISlider()
        slider.minimumTrackTintColor = .black
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(), for: .normal)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.setValue(23, animated: false)
        addSubview(slider)
    }
}