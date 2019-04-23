import UIKit
import SnapKit

class GenreCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    internal var genreImageView: UIImageView!
    internal var genreLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        genreImageView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(8)
            maker.right.equalToSuperview().inset(8)
            maker.top.equalToSuperview().offset(8)
            maker.bottom.equalToSuperview().inset(8)
        }

        genreLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.right.equalToSuperview().inset(24)
            maker.bottom.equalToSuperview().inset(24)
            maker.height.equalTo(24)
        }
    }

    override func setupView() {
        genreImageView = UIImageView()
        genreImageView.contentMode = .scaleAspectFill
        genreImageView.backgroundColor = .appColor
        genreImageView.layer.cornerRadius = 4
        addSubview(genreImageView)

        genreLabel = UILabel()
        genreLabel.text = "Genre"
        genreLabel.textColor = .white
        genreLabel.font = Font.Futura.medium(with: 20)
        genreLabel.textAlignment = .right
        addSubview(genreLabel)
    }

    internal func updateCell(_ viewModel: GenreCellViewModel) {
        genreLabel.text = viewModel.titleText
    }
}