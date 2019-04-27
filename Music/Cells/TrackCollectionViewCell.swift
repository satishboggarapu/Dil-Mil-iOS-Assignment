import UIKit
import SnapKit

class TrackCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    internal var trackNumberLabel: UILabel!
    internal var titleLabel: UILabel!
    internal var artistLabel: UILabel!
    internal var listensLabel: UILabel!
    internal var favoriteButton: UIButton!
    private var dividerView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        trackNumberLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(8)
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(14)
        }

        favoriteButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(16)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(24)
        }

        listensLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.right.equalTo(favoriteButton.snp.left).inset(16)
            maker.width.equalTo(50)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(trackNumberLabel.snp.right).offset(12)
            maker.right.equalTo(listensLabel.snp.left).inset(16)
            maker.top.bottom.equalToSuperview()
        }

        dividerView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(0.5)
        }
    }

    override func setupView() {
        titleLabel = UILabel()
        titleLabel.text = "Track Title Label"
        titleLabel.textColor = .black
        titleLabel.font = Font.Futura.medium(with: 17)
        titleLabel.textAlignment = .left
        addSubview(titleLabel)

        listensLabel = UILabel()
        listensLabel.text = "12k"
        listensLabel.textColor = .black
        listensLabel.font = Font.Futura.regular(with: 12)
        listensLabel.textAlignment = .left
        addSubview(listensLabel)

        favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(icon: .HEART_OUTLINE_24), for: .normal)
        favoriteButton.imageView?.tintColor = .black
        addSubview(favoriteButton)

        dividerView = UIView()
        dividerView.backgroundColor = .divider
        addSubview(dividerView)

        trackNumberLabel = UILabel()
        trackNumberLabel.text = "1"
        trackNumberLabel.textColor = .gray
        trackNumberLabel.font = Font.Futura.medium(with: 15)
        trackNumberLabel.textAlignment = .left
        addSubview(trackNumberLabel)
    }
    
    internal func updateCell(_ viewModel: TrackCellViewModel) {
        titleLabel.text = viewModel.titleText
        trackNumberLabel.text = viewModel.trackNumberText
        listensLabel.text = viewModel.listensText
    }
}