import Foundation

struct TrackModel: Codable {
    let id: String
    let title: String
    let trackImageUrl: String?
    let artistName: String
    let albumTitle: String?
    let trackDuration: String?
    let trackNumber: String?
    let listens: String?
    var fileUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "track_id"
        case title = "track_title"
        case trackImageUrl = "track_image_file"
        case artistName = "artist_name"
        case albumTitle = "album_title"
        case trackDuration = "track_duration"
        case trackNumber = "track_number"
        case listens = "track_listens"
        case fileUrl = "track_file_url"
    }

    mutating func setFileUrl(_ url: String) {
        self.fileUrl = url
    }
}