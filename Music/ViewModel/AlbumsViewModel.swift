import Foundation

class AlbumsViewModel {

    private(set) var albumsResponseModel: AlbumsResponseModel!
    private var fmaManager: FMAManager!
    private var isLoading: Bool!
    private var genre: GenreModel!

    private var cellViewModels = [AlbumCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }

    internal var numberOfCells: Int {
        return cellViewModels.count
    }

    // MARK: Closure's
    internal var reloadCollectionViewClosure: (() -> ())?

    init(genre: GenreModel) {
        self.genre = genre
        fmaManager = FMAManager()
        isLoading = false
    }
    
    internal func fetchAlbums() {
        if isLoading {
            return
        }

        if let albumsResponseModel = albumsResponseModel,
           albumsResponseModel.totalPages == Int(albumsResponseModel.currentPage) {
            return
        }

        isLoading = true
        let currentPage = (albumsResponseModel == nil) ? 0 : Int(albumsResponseModel.currentPage)!
        let nextPage = currentPage + 1
        fmaManager.getAlbums(genre: genre, page: nextPage) { response, error in
            guard let response = response, error == nil else {
                self.isLoading = false
                return
            }

            if self.albumsResponseModel == nil {
                self.albumsResponseModel = response
            } else {
                self.albumsResponseModel.update(response)
            }
            self.appendAlbumCellViewModels(response.albums)
            self.isLoading = false
        }
    }
    
    private func appendAlbumCellViewModels(_ albums: [AlbumModel]) {
        var albumCellViewModels = [AlbumCellViewModel]()
        albums.forEach { album in
            let album = AlbumCellViewModel(titleText: album.title, artistText: album.artistName, imageUrl: album.imageURL)
            albumCellViewModels.append(album)
        }
        self.cellViewModels.append(contentsOf: albumCellViewModels)
    }

    internal func getCellViewModel(_ indexPath: IndexPath) -> AlbumCellViewModel {
        return cellViewModels[indexPath.row]
    }

    internal func getAlbumForCell(_ indexPath: IndexPath) -> AlbumModel {
        return albumsResponseModel.albums[indexPath.row]
    }
}