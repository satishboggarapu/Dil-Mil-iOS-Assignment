import UIKit

extension UIImage {

    enum Icon: String {
        case SEARCH = "baseline_search_white_24pt"
        case LIBRARY = "baseline_library_music_white_24pt"
        case NOW_PLAYING = "ic_music_24dp"
        case LEFT_ARROW = "baseline_arrow_back_white_24pt"
        case HEART_OUTLINE_24 = "round_favorite_border_white_24pt"
        case HEART_OUTLINE_36 = "round_favorite_border_white_36pt"
        case HEART_FILL_24 = "round_favorite_white_24pt"
        case HEART_FILL_36 = "round_favorite_white_36pt"
        case PLAY_24 = "round_play_arrow_white_24pt"
        case PLAY_36 = "round_play_arrow_white_36pt"
        case PLAY_48 = "round_play_arrow_white_48pt"
        case PAUSE_24 = "round_pause_white_24pt"
        case PAUSE_36 = "round_pause_white_36pt"
        case PAUSE_48 = "round_pause_white_48pt"
        case PREVIOUS_TRACK_36 = "round_skip_previous_white_36pt"
        case NEXT_TRACK_36 = "round_skip_next_white_36pt"
    }

    convenience init!(icon: Icon) {
        self.init(named: icon.rawValue)
    }
}