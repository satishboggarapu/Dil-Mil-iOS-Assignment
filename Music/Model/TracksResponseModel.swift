import Foundation

struct TracksResponseModel: Decodable {
    var totalPages: Int
    var currentPage: String
    var tracks: [TrackModel]

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case currentPage = "page"
        case tracks = "dataset"
    }

    mutating func update(_ response: TracksResponseModel) {
        totalPages = response.totalPages
        currentPage = response.currentPage
        tracks.append(contentsOf: response.tracks)
    }
}