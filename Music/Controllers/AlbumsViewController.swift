import UIKit
import SnapKit

class AlbumsViewController: UIViewController {

    // MARK: UIElements
    internal var collectionView: UICollectionView!

    // MARK: Attributes
    private var genre: GenreModel!
    private var viewModel: AlbumsViewModel!

    convenience init(genre: GenreModel) {
        self.init()
        self.genre = genre
        viewModel = AlbumsViewModel(genre: genre)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .viewBackground

        setupView()
        addConstraints()

        initializeAlbumViewModel()
    }

    private func initializeAlbumViewModel() {

        viewModel.reloadCollectionViewClosure = { () in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        viewModel.fetchAlbums()
    }

    override func setupView() {
        let layout = UICollectionViewFlowLayout()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(collectionView)
    }

    override func addConstraints() {
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}

extension AlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//viewModel.numberOfCells
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AlbumCollectionViewCell ?? AlbumCollectionViewCell()

//        let cellViewModel = viewModel.getCellViewModel(indexPath)
//        cell.updateCell(cellViewModel)
//
//        if indexPath.row == viewModel.numberOfCells - 6 {
//            viewModel.fetchAlbums()
//        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let album = viewModel.getAlbumForCell(indexPath)
        let album = AlbumModel(id: "", title: "", type: "", artistName: "", releaseDate: "", imageURL: "")
        navigationController?.pushViewController(AlbumViewController(album: album), animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - 16) / 2.0
        let height: CGFloat = width + 34 + 12
        return CGSize(width: width, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}