import Foundation

class TracksViewModel {

    private(set) var tracksResponseModel: TracksResponseModel!
    private var fmaManager: FMAManager!
    private var isLoading: Bool!
    private var album: AlbumModel!

    private var cellViewModels = [TrackCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }

    internal var numberOfCells: Int {
        return cellViewModels.count
    }

    // MARK: Closure's
    internal var reloadCollectionViewClosure: (() -> ())?


    init(album: AlbumModel) {
        self.album = album
        fmaManager = FMAManager()
        isLoading = false
    }
    
    internal func fetchTracks() {
        if isLoading {
            return
        }

        if let trackResponse = tracksResponseModel,
           trackResponse.totalPages == Int(trackResponse.currentPage) {
            return
        }

        isLoading = true
        let currentPage = (tracksResponseModel == nil) ? 0 : Int(tracksResponseModel.currentPage)!
        let nextPage = currentPage + 1
        fmaManager.getTracks(album: album, page: nextPage) { response, error in
            guard let response = response, error == nil else {
                self.isLoading = false
                return
            }

            if self.tracksResponseModel == nil {
                self.tracksResponseModel = response
            } else {
                self.tracksResponseModel.update(response)
            }
            self.appendTrackCellViewModels(response.tracks)
            self.isLoading = false
        }
    }
    
    private func appendTrackCellViewModels(_ tracks: [TrackModel]) {
        var trackCellViewModels = [TrackCellViewModel]()
        tracks.forEach { model in
            let track = TrackCellViewModel(track: model)
            trackCellViewModels.append(track)
        }
        self.cellViewModels.append(contentsOf: trackCellViewModels)
    }

    internal func getCellViewModel(_ indexPath: IndexPath) -> TrackCellViewModel {
        return cellViewModels[indexPath.row]
    }

    internal func getGenreForCell(_ indexPath: IndexPath) -> TrackModel {
        return tracksResponseModel.tracks[indexPath.row]
    }
}