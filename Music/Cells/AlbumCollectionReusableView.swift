import UIKit
import SnapKit

class AlbumCollectionReusableView: UICollectionReusableView {

    // MARK: UIElements
    var albumTitle: UILabel!
    var albumInfo: UILabel!
    var dividerView: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        albumInfo.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().inset(16)
            maker.bottom.equalToSuperview().inset(8)
            maker.height.equalTo(18)
        }

        albumTitle.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(4)
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().inset(16)
            maker.bottom.equalTo(albumInfo.snp.top).inset(6)
        }

        dividerView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(2)
        }
    }

    override func setupView() {
        albumTitle = UILabel()
        albumTitle.text = "Album Title"
        albumTitle.textColor = .black
        albumTitle.font = Font.Futura.medium(with: 20)
        albumTitle.textAlignment = .left
        albumTitle.numberOfLines = 0
        albumTitle.lineBreakMode = .byWordWrapping
        addSubview(albumTitle)

        albumInfo = UILabel()
        albumInfo.text = "Album info"
        albumInfo.textColor = .black
        albumInfo.font = Font.Futura.regular(with: 16)
        addSubview(albumInfo)

        dividerView = UIView()
        dividerView.backgroundColor = .divider
        addSubview(dividerView)
    }

    func update(_ album: AlbumModel) {
        self.albumTitle.text = album.title
        self.albumInfo.text = album.artistName
    }
}