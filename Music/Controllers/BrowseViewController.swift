import UIKit
import SnapKit

class BrowseViewController: UIViewController {

    // MARK: UIElements
    internal var collectionView: UICollectionView!

    // MARK: Attributes
    lazy var viewModel: GenresViewModel = {
        return GenresViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .viewBackground
        viewModel = GenresViewModel()

        setupNavigationBar()
        setupView()
        addConstraints()

        initializeGenreViewModel()
    }

    private func initializeGenreViewModel() {

        ///
        viewModel.reloadCollectionViewClosure = { () in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        viewModel.fetchGenres()
    }

    override func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = false

        let titleLabel = UILabel()
        titleLabel.text = "Genres"
        titleLabel.textColor = .black
        titleLabel.font = Font.Futura.medium(with: 24)

        navigationItem.titleView = titleLabel
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
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(collectionView)
    }

    override func addConstraints() {
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}

extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//viewModel.numberOfCells
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GenreCollectionViewCell ?? GenreCollectionViewCell()

//        let cellViewModel = viewModel.getCellViewModel(indexPath)
//        cell.updateCell(cellViewModel)
//
//        if indexPath.row == viewModel.numberOfCells - 6 {
//            viewModel.fetchGenres()
//        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let genre = viewModel.getGenreForCell(indexPath)
        let genre = GenreModel(id: "sjdc", parentId: "sdj", title: "skjd", handle: "skjdn", color: "sjdn")
        navigationController?.pushViewController(AlbumsViewController(genre: genre), animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16
        return CGSize(width: width, height: 128)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
