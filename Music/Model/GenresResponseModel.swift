import Foundation

struct GenresResponseModel: Codable {
    private(set) var totalPages: Double
    private(set) var currentPage: String
    private(set) var genres: [GenreModel]

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