import UIKit

extension UIImage {

    enum Icon: String {
        case SEARCH = "baseline_search_white_24pt"
        case LIBRARY = "baseline_library_music_white_24pt"
        case NOW_PLAYING = "ic_music_24dp"
    }

    convenience init!(icon: Icon) {
        self.init(named: icon.rawValue)
    }
}