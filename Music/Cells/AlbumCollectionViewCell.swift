import UIKit
import SnapKit
import SDWebImage

class AlbumCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    internal var view: UIView!
    internal var imageView: UIImageView!
    internal var titleLabel: UILabel!
    internal var artistLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        view.snp.makeConstraints { maker in
            maker.left.top.equalToSuperview().offset(8)
            maker.right.bottom.equalToSuperview().inset(8)
        }

        artistLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(8)
            maker.right.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(8)
            maker.height.equalTo(12)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(8)
            maker.right.equalToSuperview().inset(8)
            maker.bottom.equalTo(artistLabel.snp.top).inset(-4)
            maker.height.equalTo(22)
        }

        imageView.snp.makeConstraints { maker in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalTo(titleLabel.snp.top).inset(-4)
        }
    }

    override func setupView() {
        view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        addSubview(view)

        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 4
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)

        titleLabel = UILabel()
        titleLabel.text = "Album Title"
        titleLabel.textColor = .black
        titleLabel.font = Font.Futura.medium(with: 16)
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)

        artistLabel = UILabel()
        artistLabel.text = "Artist Label"
        artistLabel.textColor = .black
        artistLabel.font = Font.Futura.regular(with: 14)
        artistLabel.textAlignment = .left
        view.addSubview(artistLabel)
    }

    internal func updateCell(_ viewModel: AlbumCellViewModel) {
        titleLabel.text = viewModel.titleText
        artistLabel.text = viewModel.artistText

        let imageURL = URL(string: viewModel.imageUrl)
        imageView.sd_setImage(with: imageURL, placeholderImage: nil, completed: nil)
        // TODO Cache images

    }
}
