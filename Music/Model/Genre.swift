import Foundation

struct Genre: Decodable {
    let id: String
    let parentId: String?
    let title: String
    let handle: String
    let color: String

    enum CodingKeys: String, CodingKey {
        case id = "genre_id"
        case parentId = "genre_parent_id"
        case title = "genre_title"
        case handle = "genre_handle"
        case color = "genre_color"
    }
}