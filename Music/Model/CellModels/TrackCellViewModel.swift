import Foundation

struct TrackCellViewModel {
    let model: TrackModel
    let titleText: String
    let trackNumberText: String
    let trackImageUrl: String
    let albumTitleText: String

    init(track: TrackModel) {
        self.model = track
        self.titleText = track.title
        self.trackNumberText = track.trackNumber ?? ""
        self.trackImageUrl = track.trackImageUrl ?? ""
        self.albumTitleText = track.albumTitle ?? ""
    }

    var listensText: String {
        guard let num = Int(model.listens ?? "0") else {
            return ""
        }

        // less than 1000, no abbreviation
        if num < 1000 {
            return "\(num)"
        }

        // less than 1 million, abbreviate to thousands with K
        if num < 1000000 {
            var n = Double(num)
            n = Double(floor(n/100)/10)
            return "\(n.description)K"
        }

        // more than a million, abbreviate to millions with M
        var n = Double(num)
        n = Double(floor(n/100000)/10)
        return "\(n.description)M"
    }
}