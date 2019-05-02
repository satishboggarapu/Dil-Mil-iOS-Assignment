import Foundation

class TracksViewModel {

    private(set) var tracksResponseModel: TracksResponseModel!
    private var fmaManager: FMAManager!
    private var isLoading: Bool!
    private var genre: GenreModel!

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


    init(genre: GenreModel) {
        self.genre = genre
        fmaManager = FMAManager()
        isLoading = false
    }
    
    internal func fetchTracks() {
        if isLoading {
            return
        }

//        if let trackResponse = tracksResponseModel,
//           trackResponse.totalPages == Int(trackResponse.currentPage) {
//            return
//        }

//        self.isLoading = true
//        let tracks = ["188044", "188043", "188042", "188041", "188040", "188039",
//                      "187968", "187957", "187956", "187955"]
//
//
//        let dispatchGroup = DispatchGroup()
//        var trackModels = [TrackModel]()
//        for track in tracks {
//            dispatchGroup.enter()
//            fmaManager.getTrack(trackId: track) { model, error in
//                if let model = model {
//                    trackModels.append(model)
//                }
//                dispatchGroup.leave()
//            }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            self.isLoading = false
//            self.tracksResponseModel = TracksResponseModel(totalPages: 1, currentPage: "1", tracks: trackModels)
//            self.appendTrackCellViewModels(trackModels)
//        }


        isLoading = true
        let currentPage = 1//(tracksResponseModel == nil) ? 0 : Int(tracksResponseModel.currentPage)!
        let nextPage = currentPage + 1
        fmaManager.getTracks(genre: genre, page: nextPage) { response, error in
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