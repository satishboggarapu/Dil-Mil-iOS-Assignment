import Foundation

struct AlbumsResponseModel: Decodable {
    var totalPages: Int
    var currentPage: String
    var albums: [AlbumModel]

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case currentPage = "page"
        case albums = "dataset"
    }

    mutating func update(_ response: AlbumsResponseModel) {
        totalPages = response.totalPages
        currentPage = response.currentPage
        albums.append(contentsOf: response.albums)
    }
}