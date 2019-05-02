import Foundation

struct TracksResponseModel: Codable {
    private(set) var totalPages: Int
    private(set) var currentPage: String
    private(set) var tracks: [TrackModel]

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