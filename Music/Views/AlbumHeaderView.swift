import UIKit
import SnapKit

protocol AlbumHeaderViewDelegate: class {
    func backButtonAction()
}

class AlbumHeaderView: UIView {

    // MARK: UIElements
    var albumImageView: UIImageView!
    private var backButton: UIButton!

    // MARK: Attributes
    weak var delegate: AlbumHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        albumImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.top.equalToSuperview().offset(statusBarHeight + 16)
            maker.size.equalTo(24)
        }

    }

    override func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .white

        albumImageView = UIImageView()
        albumImageView.backgroundColor = .gray
        albumImageView.contentMode = .scaleAspectFill
        addSubview(albumImageView)

        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(icon: .LEFT_ARROW), for: .normal)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        addSubview(backButton)
    }

    @objc private func backButtonAction() {
        delegate?.backButtonAction()
    }
}