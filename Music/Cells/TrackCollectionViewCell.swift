import UIKit
import SnapKit
import SDWebImage
import NVActivityIndicatorView

class TrackCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    var albumView: UIView!
    var albumImageView: UIImageView!
    var trackTitleLabel: UILabel!
    var trackAlbumLabel: UILabel!
    var listensImageView: UIImageView!
    var listensLabel: UILabel!
    var animationView: NVActivityIndicatorView!
    var equalizerImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        addConstraints()

//        albumImageView.sd_setImage(with: URL(string: "https://freemusicarchive.org/file/images/artists/the_tunnel_-_20150909203729678.jpg"), placeholderImage: nil)
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
        trackTitleLabel.text = "Track Title"
        trackTitleLabel.textColor = .black
        trackTitleLabel.font = Font.Futura.medium(with: 18)
        trackTitleLabel.textAlignment = .left
        addSubview(trackTitleLabel)

        trackAlbumLabel = UILabel()
        trackAlbumLabel.text = "Album Label"
        trackAlbumLabel.textColor = .black
        trackAlbumLabel.font = Font.Futura.regular(with: 16)
        trackAlbumLabel.textAlignment = .left
        addSubview(trackAlbumLabel)

        listensLabel = UILabel()
        listensLabel.text = "12.4K"
        listensLabel.textColor = .darkGray
        listensLabel.font = Font.Futura.regular(with: 13)
        listensLabel.textAlignment = .left
        addSubview(listensLabel)

        listensImageView = UIImageView()
        listensImageView.image = UIImage(icon: .PLAY_24)
        listensImageView.tintColor = .darkGray
        addSubview(listensImageView)

        animationView = NVActivityIndicatorView(frame: .zero)
        animationView.type = .audioEqualizer
        animationView.color = .darkGray
        addSubview(animationView)

        equalizerImageView = UIImageView()
        equalizerImageView.image = UIImage(icon: .EQUALIZER_24)
        equalizerImageView.tintColor = .darkGray
        equalizerImageView.isHidden = true
        addSubview(equalizerImageView)
    }

    override func addConstraints() {
        animationView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(0)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(24)
        }

        equalizerImageView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(0)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(24)
        }

        albumView.snp.makeConstraints { maker in
            maker.left.equalTo(animationView.snp.right).offset(12)
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

    internal func updateCell(_ viewModel: TrackCellViewModel) {
        albumImageView.sd_setImage(with: URL(string: viewModel.trackImageUrl), placeholderImage: nil)
        trackTitleLabel.text = viewModel.titleText
        trackAlbumLabel.text = viewModel.albumTitleText
        listensLabel.text = viewModel.listensText

        listensLabel.snp.updateConstraints { maker in
            maker.width.equalTo(listensLabel.intrinsicContentSize.width)
        }
    }
    
    internal func toggleAnimation(isCurrentTrack: Bool, isPlaying: Bool) {
        _ = isCurrentTrack ? animationView.startAnimating() : animationView.stopAnimating()

//        if isCurrentTrack {
//            _ = isPlaying ? animationView.startAnimating() : animationView.stopAnimating()
//            equalizerImageView.isHidden = isPlaying
//        } else {
//            animationView.stopAnimating()
//            equalizerImageView.isHidden = true
//        }
    }
}