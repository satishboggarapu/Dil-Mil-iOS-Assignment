import Foundation
import AVFoundation

/**
    Singleton class to control AudioPlayer throughout the app.
 */
class Player: NSObject {

    private static var playerInstance: Player!
    private var currentTrackIndex: Int?
    private var playlist: TracksResponseModel?
    private var songCache = NSCache<NSString, NSData>()
    private var audioPlayer = AVPlayer()
    private var fmaManager = FMAManager()

    public static func getInstance() -> Player {
        if playerInstance == nil {
            playerInstance = Player()
        }
        return playerInstance
    }

    /// Setter method called when new track is selected in TrackViewController. Updates values and plays current track
    /// Parameters:
    ///     - mode: TrackResponseModel object, which treated as a playlist
    ///     - trackIndex: index of the track selected in model.tracks array
    func didSelectNewSongToPlay(model: TracksResponseModel, trackIndex: Int) {
        self.playlist = model
        self.currentTrackIndex = trackIndex
        playCurrentTrack()
    }

    /// Plays current track. Fires newTrackSelected and trackLoading notifications.
    /// Checks local cache if song already downloaded first before making a url request
    private func playCurrentTrack() {
        NotificationCenter.default.post(name: .newTrackSelected, object: nil)
        NotificationCenter.default.post(name: .trackLoading, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer.currentItem)
        DispatchQueue.global(qos: .background).async {
            if let track = self.getCurrentTrack(), let fileUrl = track.fileUrl {
                print(fileUrl)
                if let data = self.songCache.object(forKey: fileUrl as NSString) {
                    let playerItem = CachingPlayerItem(data: data as Data, mimeType: "audio/mpeg", fileExtension: "mp3")
                    playerItem.delegate = self
                } else if let url = URL(string: fileUrl) {
                    let playerItem = CachingPlayerItem(url: url, customFileExtension: "mp3")
                    playerItem.delegate = self
                }
            }
        }
    }

    /// Skips current track to next by incrementing the currentTrackIndex and calls playCurrentTrack() method
    func nextTrack() {
        currentTrackIndex = (currentTrackIndex == (playlist?.tracks.count ?? 0) - 1) ? currentTrackIndex : currentTrackIndex! + 1
        playCurrentTrack()
    }

    /// Go back to previous track by decrementing the currentTrackIndex and calls playCurrentTrack() method
    func previousTrack() {
        currentTrackIndex = (currentTrackIndex! == 0) ? 0 : currentTrackIndex! - 1
        playCurrentTrack()
    }

    /// Pauses audioPlayer and fires .trackPaused notification
    func pauseTrack() {
        audioPlayer.pause()
        NotificationCenter.default.post(name: .trackPaused, object: nil)
    }

    /// Resumes audioPlayer and fires .trackResume notificaiton
    func resumeTrack() {
        audioPlayer.play()
        NotificationCenter.default.post(name: .trackResumed, object: nil)
    }

    /// Toggles audioPlayer playPause state
    func togglePlayPauseState() {
        if isTrackPaused() {
            resumeTrack()
        } else {
            pauseTrack()
        }
    }

    func getCurrentTrackIndex() -> Int? {
        return currentTrackIndex
    }

    func getCurrentTrack() -> TrackModel? {
        return playlist?.tracks[currentTrackIndex ?? 0]
    }

    /// Returns true if audioPlayer is paused else false
    func isTrackPaused() -> Bool {
        return audioPlayer.rate == 0 && audioPlayer.error == nil
    }

    func getAudioPlayerCurrentItem() -> AVPlayerItem? {
        return audioPlayer.currentItem
    }

    /// Seek audio player a provide CMTime
    /// Parameters:
    ///     - time: CMTime object to seek to
    func seekAudioPlayerTo(time: CMTime, completion: @escaping (() -> Void)) {
        audioPlayer.seek(to: time) { (b: Bool) -> Void in
            return completion()
        }
    }

    /// Returns value from 0 to 1 for slider in MusicPlayerViewController
    func getSliderValue() -> Float {
        let currentTime = audioPlayer.currentTime()
        let seconds = CMTimeGetSeconds(currentTime)
        if let duration = audioPlayer.currentItem?.asset.duration, !seconds.isNaN {
            let durationSeconds = CMTimeGetSeconds(duration)
            var sliderValue = CGFloat(seconds / durationSeconds)
            if durationSeconds.isNaN {
                sliderValue = 0
            }
            return Float(sliderValue)
        }
        return 0
    }

    /// Returns current track time from the audioPlayer for MusicPlayerViewController
    func getTrackCurrentTime() -> String {
        let currentTime = audioPlayer.currentTime()
        if currentTime.isValid {
            let seconds = CMTimeGetSeconds(currentTime)
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minuteString = String(Int(seconds / 60))
            return "\(minuteString):\(secondsString)"
        }
        return "0:00"
    }
}

extension Player: CachingPlayerItemDelegate {
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        if let url = (playerItem.asset as? AVURLAsset)?.url {
            var cleanUrl = url.absoluteString
            cleanUrl = cleanUrl.replacingOccurrences(of: "cachingPlayerItemScheme", with: "https")
            cleanUrl = cleanUrl.replacingOccurrences(of: ".mp3", with: "")
            songCache.setObject(data as NSData, forKey: cleanUrl as NSString)
        }
    }

    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        // TODO
    }

    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print("downloadingFailedWith ", error)
    }

    func playerItemReadyToPlay(_ playerItem: CachingPlayerItem) {
        audioPlayer.replaceCurrentItem(with: playerItem)
        audioPlayer.play()
//        print(audioPlayer.reasonForWaitingToPlay?.rawValue)
        if audioPlayer.reasonForWaitingToPlay == AVPlayer.WaitingReason.noItemToPlay {
            playCurrentTrack()
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer.currentItem)
        NotificationCenter.default.post(name: .trackReadyToPlay, object: nil)
    }

    /// Observer method triggered when audioPlayer finishes playing track
    @objc private func audioPlayerDidFinishPlaying() {
        nextTrack()
    }
}