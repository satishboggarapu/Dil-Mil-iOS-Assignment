import Foundation

struct TrackModel: Decodable {
    let id: String
    let title: String
    let artistName: String
    let fileUrl: String
    let listens: String
    let trackNumber: String

    enum CodingKeys: String, CodingKey {
        case id = "track_id"
        case title = "track_title"
        case artistName = "artist_name"
        case fileUrl = "track_file"
        case listens = "track_listens"
        case trackNumber = "track_number"
    }
}