import Foundation

struct GenreResponse: Decodable {
    var totalPages: Double
    var currentPage: String
    var genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case currentPage = "page"
        case genres = "dataset"
    }

    mutating func update(_ response: GenreResponse) {
        totalPages = response.totalPages
        currentPage = response.currentPage
        genres.append(contentsOf: response.genres)
    }
}