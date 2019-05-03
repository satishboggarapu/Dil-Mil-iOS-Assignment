import Foundation
import AVFoundation

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

    func didSelectNewSongToPlay(model: TracksResponseModel, trackIndex: Int) {
        self.playlist = model
        self.currentTrackIndex = trackIndex
        playCurrentTrack()
    }

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

    func nextTrack() {
        currentTrackIndex = (currentTrackIndex == (playlist?.tracks.count ?? 0) - 1) ? currentTrackIndex : currentTrackIndex! + 1
        playCurrentTrack()
    }

    func previousTrack() {
        currentTrackIndex = (currentTrackIndex! == 0) ? 0 : currentTrackIndex! - 1
        playCurrentTrack()
    }

    func pauseTrack() {
        audioPlayer.pause()
        NotificationCenter.default.post(name: .trackPaused, object: nil)
    }

    func resumeTrack() {
        audioPlayer.play()
        NotificationCenter.default.post(name: .trackResumed, object: nil)
    }

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

    func isTrackPaused() -> Bool {
        return audioPlayer.rate == 0 && audioPlayer.error == nil
    }

    func getAudioPlayerCurrentItem() -> AVPlayerItem? {
        return audioPlayer.currentItem
    }

    func seekAudioPlayerTo(time: CMTime, completion: @escaping (() -> Void)) {
        audioPlayer.seek(to: time) { (b: Bool) -> Void in
            return completion()
        }
    }

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
//        print("didFinishDownloadingData")
        if let url = (playerItem.asset as? AVURLAsset)?.url {
            var cleanUrl = url.absoluteString
            cleanUrl = cleanUrl.replacingOccurrences(of: "cachingPlayerItemScheme", with: "https")
            cleanUrl = cleanUrl.replacingOccurrences(of: ".mp3", with: "")
            songCache.setObject(data as NSData, forKey: cleanUrl as NSString)
        }
    }

    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
//        print("playerItemPlaybackStalled")
    }

    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print("downloadingFailedWith ", error)
    }

    func playerItemReadyToPlay(_ playerItem: CachingPlayerItem) {
//        print("playerItemReadyToPlay")
        audioPlayer.replaceCurrentItem(with: playerItem)
        audioPlayer.play()
        print(audioPlayer.reasonForWaitingToPlay?.rawValue)
        if audioPlayer.reasonForWaitingToPlay == AVPlayer.WaitingReason.noItemToPlay {
            playCurrentTrack()
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer.currentItem)
        NotificationCenter.default.post(name: .trackReadyToPlay, object: nil)
    }

    @objc private func audioPlayerDidFinishPlaying() {
        nextTrack()
    }
}