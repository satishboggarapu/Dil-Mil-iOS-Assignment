import Foundation

struct GenresResponseModel: Decodable {
    var totalPages: Double
    var currentPage: String
    var genres: [GenreModel]

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case currentPage = "page"
        case genres = "dataset"
    }

    mutating func update(_ response: GenresResponseModel) {
        totalPages = response.totalPages
        currentPage = response.currentPage
        genres.append(contentsOf: response.genres)
    }
}