import Foundation

class GenresViewModel {

    private(set) var genreResponse: GenresResponseModel!
    private var fmaManager: FMAManager!
    private var isLoading: Bool!

    private var cellViewModels = [GenreCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }

    internal var numberOfCells: Int {
        return cellViewModels.count
    }

    // MARK: Closure's
    internal var reloadCollectionViewClosure: (() -> ())?


    init() {
        fmaManager = FMAManager()
        isLoading = false
    }
    
    internal func fetchGenres() {
        if isLoading {
            return
        }

        if let genreResponse = genreResponse,
           genreResponse.totalPages == Double(genreResponse.currentPage) {
            return
        }

        isLoading = true
        let currentPage = (genreResponse == nil) ? 0 : Int(genreResponse.currentPage)!
        let nextPage = currentPage + 1
        fmaManager.getGenres(page: nextPage) { response, error in
            guard let response = response, error == nil else {
                self.isLoading = false
                return
            }

            if self.genreResponse == nil {
                self.genreResponse = response
            } else {
                self.genreResponse.update(response)
            }
            self.appendGenreCellViewModels(response.genres)
            self.isLoading = false
        }
    }
    
    private func appendGenreCellViewModels(_ genres: [GenreModel]) {
        var genreCellViewModels = [GenreCellViewModel]()
        genres.forEach { genre in
            let genreCellViewModel = GenreCellViewModel(genre: genre)
            genreCellViewModels.append(genreCellViewModel)
        }
        self.cellViewModels.append(contentsOf: genreCellViewModels)
    }

    internal func getCellViewModel(_ indexPath: IndexPath) -> GenreCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    internal func getGenreForCell(_ indexPath: IndexPath) -> GenreModel {
        return genreResponse.genres[indexPath.row]
    }
}
