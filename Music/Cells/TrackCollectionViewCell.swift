import UIKit
import SnapKit
import SDWebImage
import Lottie

class TrackCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    var albumView: UIView!
    var albumImageView: UIImageView!
    var trackTitleLabel: UILabel!
    var trackAlbumLabel: UILabel!
    var listensImageView: UIImageView!
    var listensLabel: UILabel!
    var animationView: LOTAnimationView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        albumView.layer.shadowPath = UIBezierPath(rect: albumView.bounds).cgPath
    }

    override func setupView() {
        albumView = UIView()
        albumView.backgroundColor = .white
        albumView.layer.cornerRadius = 4
        albumView.layer.shadowOffset = .zero
        albumView.layer.shadowColor = UIColor.darkGray.cgColor
        albumView.layer.shadowRadius = 4
        albumView.layer.shadowOpacity = 0.75
        addSubview(albumView)

        albumImageView = UIImageView()
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 4
        albumImageView.clipsToBounds = true
        albumView.addSubview(albumImageView)

        trackTitleLabel = UILabel()
        trackTitleLabel.textColor = .black
        trackTitleLabel.font = Font.Futura.medium(with: 18)
        trackTitleLabel.textAlignment = .left
        addSubview(trackTitleLabel)

        trackAlbumLabel = UILabel()
        trackAlbumLabel.textColor = .black
        trackAlbumLabel.font = Font.Futura.regular(with: 16)
        trackAlbumLabel.textAlignment = .left
        addSubview(trackAlbumLabel)

        listensLabel = UILabel()
        listensLabel.textColor = .darkGray
        listensLabel.font = Font.Futura.regular(with: 13)
        listensLabel.textAlignment = .left
        addSubview(listensLabel)

        listensImageView = UIImageView()
        listensImageView.image = UIImage(icon: .PLAY_24)
        listensImageView.tintColor = .darkGray
        addSubview(listensImageView)

        animationView = LOTAnimationView(name: LottieAnimation.equalizer)
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        animationView.isHidden = true
        addSubview(animationView)
    }

    override func addConstraints() {
        animationView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(-50)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(128)
        }

        albumView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(36)
            maker.top.equalToSuperview().offset(6)
            maker.bottom.equalToSuperview().inset(6)
            maker.width.equalTo(self.bounds.height - 12)
        }

        albumImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        listensLabel.snp.makeConstraints { maker in
            maker.top.equalTo(albumView)
            maker.bottom.equalTo(albumView)
            maker.right.equalToSuperview().inset(24)
            maker.width.equalTo(35)
        }

        listensImageView.snp.makeConstraints { maker in
            maker.right.equalTo(listensLabel.snp.left)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(18)
        }

        trackTitleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(albumView.snp.right).offset(24)
            maker.top.equalTo(albumView.snp.top).offset(2)
            maker.bottom.equalTo(albumView.snp.centerY).inset(-1)
            maker.right.equalTo(listensImageView.snp.left).inset(-16)
        }

        trackAlbumLabel.snp.makeConstraints { maker in
            maker.left.equalTo(albumView.snp.right).offset(24)
            maker.top.equalTo(albumView.snp.centerY).offset(1)
            maker.bottom.equalTo(albumView.snp.bottom).inset(6)
            maker.right.equalTo(listensImageView.snp.left).inset(-16)
        }
    }

    func updateCell(_ viewModel: TrackCellViewModel) {
        albumImageView.sd_setImage(with: URL(string: viewModel.trackImageUrl), placeholderImage: nil)
        trackTitleLabel.text = viewModel.titleText
        trackAlbumLabel.text = viewModel.albumTitleText
        listensLabel.text = viewModel.listensText

        listensLabel.snp.updateConstraints { maker in
            maker.width.equalTo(listensLabel.intrinsicContentSize.width)
        }
    }
    
    func toggleAnimation(isCurrentTrack: Bool, isPlaying: Bool) {
        _ = isCurrentTrack ? animationView.startAnimation() : animationView.stopAnimation()
        _ = isPlaying ? animationView.startAnimation() : animationView.stop()
    }
}