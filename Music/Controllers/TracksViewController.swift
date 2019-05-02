import UIKit
import SnapKit

class TracksViewController: UIViewController {

    // MARK: UIElements
    internal var collectionView: UICollectionView!
    internal var player: Player!

    // MARK: Attributes
    private var genre: GenreModel!
    private var viewModel: TracksViewModel!

    convenience init(genre: GenreModel) {
        self.init()
        self.genre = genre
        self.viewModel = TracksViewModel(genre: genre)
        self.player = Player.getInstance()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupNavigationBar()
        setupView()
        addConstraints()
        initializeViewModel()

        NotificationCenter.default.addObserver(self, selector: #selector(newTrackStartedPlaying(_:)), name: .newTrackSelected, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: .newTrackSelected, object: nil)
    }

    private func initializeViewModel() {
        ///
        viewModel.reloadCollectionViewClosure = { () in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        viewModel.fetchTracks()
    }

    override func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "\(genre.title)"
        titleLabel.textColor = .black
        titleLabel.font = Font.Futura.medium(with: 24)
        navigationItem.titleView = titleLabel

        let backButton = UIBarButtonItem(image: UIImage(icon: .LEFT_ARROW), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
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
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(collectionView)
    }

    override func addConstraints() {
        collectionView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).inset(54)
        }
    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func newTrackStartedPlaying(_ notification: Notification) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension TracksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackCollectionViewCell ?? TrackCollectionViewCell()

        let cellViewModel = viewModel.getCellViewModel(indexPath)
        cell.updateCell(cellViewModel)

        if let track = player.getCurrentTrack(), track.id == cellViewModel.model.id {
            cell.toggleAnimation(isCurrentTrack: true, isPlaying: !player.isTrackPaused())
        } else {
            cell.toggleAnimation(isCurrentTrack: false, isPlaying: false)
        }

        if indexPath.row == viewModel.numberOfCells - 6 {
            viewModel.fetchTracks()
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellViewModel = viewModel.getCellViewModel(indexPath)
        if let track = player.getCurrentTrack(), track.id == cellViewModel.model.id {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackCollectionViewCell
            player.togglePlayPauseState()
            cell?.toggleAnimation(isCurrentTrack: true, isPlaying: !player.isTrackPaused())
        } else {
            player.didSelectNewSongToPlay(model: viewModel.tracksResponseModel, trackIndex: indexPath.row)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16
        return CGSize(width: width, height: 64)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

}
