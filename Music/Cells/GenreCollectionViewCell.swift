import UIKit
import SnapKit

class GenreCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    var genreView: UIView!
    var genreLabel: UILabel!

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

        genreView.layer.shadowPath = UIBezierPath(rect: genreView.bounds).cgPath
    }

    override func addConstraints() {
        genreView.snp.makeConstraints { maker in
            maker.top.left.equalToSuperview().offset(8)
            maker.bottom.right.equalToSuperview().inset(8)
        }

        genreLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.bottom.right.equalToSuperview().inset(24)
            maker.height.equalTo(32)
        }
    }

    override func setupView() {
        genreView = UIView()
        genreView.backgroundColor = .white
        genreView.layer.cornerRadius = 4
        genreView.layer.shadowOffset = .zero
        genreView.layer.shadowColor = UIColor.lightGray.cgColor
        genreView.layer.shadowRadius = 4
        genreView.layer.shadowOpacity = 0.25
        addSubview(genreView)

        genreLabel = UILabel()
        genreLabel.text = "Genre Label"
        genreLabel.textColor = .black
        genreLabel.font = Font.Futura.medium(with: 32)
        genreLabel.textAlignment = .right
        addSubview(genreLabel)
    }

    internal func updateCell(_ viewModel: GenreCellViewModel) {
        genreLabel.text = viewModel.titleText
        genreLabel.textColor = viewModel.genreBackgroundColor
//        genreView.backgroundColor =  viewModel.genreBackgroundColor
    }
}