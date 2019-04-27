import UIKit
import SnapKit
import MaterialComponents.MaterialFlexibleHeader
import SDWebImage

class AlbumViewController: UIViewController {

    // MARK: UIElements
    private var collectionView: UICollectionView!
    private var headerView = MDCFlexibleHeaderView()
    private var albumHeaderView = AlbumHeaderView(frame: .zero)
    private let headerViewController = MDCFlexibleHeaderViewController()

    private let headerMaxHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    private let headerMinHeight: CGFloat = 39 + 56
    private var album: AlbumModel!
    private var viewModel: TracksViewModel!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        addChild(headerViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addChild(headerViewController)
    }

    convenience init(album: AlbumModel) {
        self.init()
        self.album = album
        self.viewModel = TracksViewModel(album: album)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .viewBackground
        setupView()
        addConstraints()
        setupHeaderView()
        initializeViewModel()
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        headerViewController.updateTopLayoutGuide()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupHeaderView() {
        headerViewController.view.frame = view.bounds
        view.addSubview(headerViewController.view)
        headerViewController.didMove(toParent: self)
        headerViewController.headerView.trackingScrollView = collectionView
        headerViewController.headerView.maximumHeight = headerMaxHeight
        headerViewController.headerView.minimumHeight = headerMinHeight

        let headerView = headerViewController.headerView
        albumHeaderView.delegate = self
        albumHeaderView.frame = headerView.bounds
        albumHeaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        albumHeaderView.albumImageView.sd_setImage(with: URL(string: album.imageURL), placeholderImage: nil, completed: nil)
        headerView.addSubview(albumHeaderView)
        albumHeaderView.clipsToBounds = true
    }

    override func addConstraints() {
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    override func setupView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.bounces = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(AlbumCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        view.addSubview(collectionView)
    }

    private func initializeViewModel() {

        viewModel.reloadCollectionViewClosure = { () in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        viewModel.fetchTracks()
    }
}

extension AlbumViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidScroll()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == headerViewController.headerView.trackingScrollView {
            headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let headerView = headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//viewModel.numberOfCells
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackCollectionViewCell ?? TrackCollectionViewCell()

//        let cellViewModel = viewModel.getCellViewModel(indexPath)
//        cell.updateCell(cellViewModel)
//
//        if indexPath.row == viewModel.numberOfCells - 6 {
//            viewModel.fetchTracks()
//        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath) as! AlbumCollectionReusableView
//            headerView.update(album)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 64)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

}

extension AlbumViewController: AlbumHeaderViewDelegate {
    func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}