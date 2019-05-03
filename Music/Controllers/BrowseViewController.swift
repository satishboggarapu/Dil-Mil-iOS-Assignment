import UIKit
import SnapKit
import Lottie

class BrowseViewController: UIViewController {

    // MARK: UIElements
    internal var collectionView: UICollectionView!
    internal var errorLabel: UILabel!
    internal var failAnimationView: LOTAnimationView!
    internal var loadingAnimationView: LOTAnimationView!

    // MARK: Attributes
    private var viewModel: GenresViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        viewModel = GenresViewModel()

        setupNavigationBar()
        setupView()
        addConstraints()
        loadingAnimationView.startAnimation()
        initializeViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.snp.updateConstraints { maker in
            let value = Player.getInstance().getCurrentTrackIndex() == nil ? 0 : 54
            maker.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).inset(value)
        }
    }

    private func initializeViewModel() {

        ///
        viewModel.reloadCollectionViewClosure = { () in
            DispatchQueue.main.async {
                self.loadingAnimationView.stopAnimation()
                if self.viewModel.numberOfCells == 0 {
                    self.errorLabel.isHidden = false
                    self.failAnimationView.startAnimation()
                } else {
                    self.errorLabel.isHidden = true
                    self.failAnimationView.stopAnimation()
                }
                self.collectionView.reloadData()
            }
        }

        viewModel.fetchGenres {
            DispatchQueue.main.async {
                self.loadingAnimationView.stopAnimation()
                self.errorLabel.isHidden = false
                self.failAnimationView.startAnimation()
            }
        }
    }

    override func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.25
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2

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

        errorLabel = UILabel()
        errorLabel.text = "Failed to load genres."
        errorLabel.textColor = .darkGray
        errorLabel.font = Font.Futura.medium(with: 20)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.isHidden = true
        view.addSubview(errorLabel)

        loadingAnimationView = LOTAnimationView(name: LottieAnimation.loading_infinity)
        loadingAnimationView.backgroundColor = .clear
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.loopAnimation = true
        view.addSubview(loadingAnimationView)

        failAnimationView = LOTAnimationView(name: LottieAnimation.failed_music)
        failAnimationView.backgroundColor = .clear
        failAnimationView.contentMode = .scaleAspectFit
        failAnimationView.loopAnimation = false
        failAnimationView.isHidden = true
        failAnimationView.tintColor = .darkGray
        view.addSubview(failAnimationView)
    }

    override func addConstraints() {
        collectionView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).inset(54)
        }

        errorLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.right.equalToSuperview().inset(24)
            maker.height.equalTo(errorLabel.intrinsicContentSize.height)
            maker.centerY.equalToSuperview().offset(-54)
        }

        failAnimationView.snp.makeConstraints { maker in
            maker.size.equalTo(view.frame.width * 0.4)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(errorLabel.snp.top)
        }

        loadingAnimationView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-64)
            maker.size.equalTo(view.frame.width * 0.8)
        }
    }
}

extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GenreCollectionViewCell ?? GenreCollectionViewCell()

        let cellViewModel = viewModel.getCellViewModel(indexPath)
        cell.updateCell(cellViewModel)

        if indexPath.row == viewModel.numberOfCells - 6 {
            viewModel.fetchGenres()
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = viewModel.getGenreForCell(indexPath)
//        let genre = GenreModel(id: "sjdc", parentId: "sdj", title: "skjd", handle: "skjdn", color: "sjdn")
        navigationController?.pushViewController(TracksViewController(genre: genre), animated: true)
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
