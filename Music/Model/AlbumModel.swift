import Foundation

struct AlbumModel: Decodable {
    let id: String
    let title: String
    let type: String
    let artistName: String
    let releaseDate: String?
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id = "album_id"
        case title = "album_title"
        case type = "album_type"
        case artistName = "artist_name"
        case releaseDate = "album_date_released"
        case imageURL = "album_image_file"
    }
}