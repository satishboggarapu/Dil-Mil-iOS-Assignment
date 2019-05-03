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

    /// Fetch tracks from FMA. Checks if tracks are currently being loaded first.
    /// If so return. Else checks if more currentPage == totalPages. If currentPage
    /// is less then totalPages, make async call to fetch more track.
    func fetchTracks(completion: @escaping (() -> Void) = {}) {
        if isLoading {
            return completion()
        }

        isLoading = true
        let currentPage = (tracksResponseModel == nil) ? 0 : Int(tracksResponseModel.currentPage)!
        let nextPage = currentPage + 1
        fmaManager.getTracks(genre: genre, page: nextPage) { response, error in
            guard let response = response, error == nil else {
                self.isLoading = false
                return completion()
            }

            // Make async calls to fetch track_file_url for each track
            let dispatchGroup = DispatchGroup()
            var responses = response
            for i in stride(from: 0, to: response.tracks.count, by: 1) {
                dispatchGroup.enter()
                self.fmaManager.getTrack(trackId: response.tracks[i].id) { fileUrl, error in
                    if let fileUrl = fileUrl, error == nil {
                        responses.tracks[i].setFileUrl(fileUrl)
                    }
                    dispatchGroup.leave()
                }
            }

            // execute code after all async calls returned
            dispatchGroup.notify(queue: .main) {
                if self.tracksResponseModel == nil {
                    self.tracksResponseModel = responses
                } else {
                    self.tracksResponseModel.update(responses)
                }
                self.appendTrackCellViewModels(responses.tracks)
                self.isLoading = false
            }
        }
    }

    /// Convert TrackModel to TrackCellViewModel and append to cellViewModels array
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