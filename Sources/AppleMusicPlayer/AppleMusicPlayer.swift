// The Swift Programming Language
// https://docs.swift.org/swift-book

@_exported import SwiftUI
@_exported import MusicKit
@_exported import AVFoundation

@available(macOS 14.0, macCatalyst 17.0, iOS 16.0, *)
@available(watchOS, unavailable)
public final class AppleMusicPlayer: ObservableObject {
    @Published public internal(set) var status: MusicAuthorization.Status = .notDetermined
    @Published public internal(set) var isSubscribedAppleMusic: Bool = false
    
    @Published public internal(set) var isPlaying: Bool = false
    @Published public internal(set) var currentSong: Song? = nil
    @Published public internal(set) var currentSongDuration: TimeInterval = 0
    @Published public internal(set) var currentSongPlaybackTime: TimeInterval = 0
    
    private let appleMusicPlayer = ApplicationMusicPlayer.shared
    private var previewPlayer: AVPlayer?
    
    internal var timer: Timer?
    internal var referrenceCount: Int = 0
    
    internal var playbackTime: TimeInterval {
        if isSubscribedAppleMusic {
            return ApplicationMusicPlayer.shared.playbackTime
        } else {
            return previewPlayer?.currentTime().seconds ?? 0
        }
    }
    
    public func checkIsPlaying() -> Bool {
        if isSubscribedAppleMusic {
            return ApplicationMusicPlayer.shared.state.playbackStatus == .playing
        } else {
            return previewPlayer?.timeControlStatus == .playing
        }
    }
    
    @MainActor
    public func authorize() async {
        let status = await MusicAuthorization.request()
        self.status = status
    }
    
    @MainActor
    public func checkSubscriptionStatus() async throws {
        let subscription = try await MusicSubscription.current
        self.isSubscribedAppleMusic = subscription.canPlayCatalogContent
    }
    
    @MainActor
    public func setup(with song: Song) async throws {
        if isSubscribedAppleMusic {
            ApplicationMusicPlayer.shared.queue = [song]
            try await ApplicationMusicPlayer.shared.prepareToPlay()
            self.currentSongDuration = song.duration ?? 0
        } else {
            if let previewURL = song.previewAssets?.first?.url {
                previewPlayer = AVPlayer(url: previewURL)
                self.currentSongDuration = 30
            } else {
                print("⚠️ 프리뷰 URL이 없습니다.")
            }
        }
        self.currentSong = song
    }
    
    @MainActor
    public func play(song: Song) async throws {
        try await setup(with: song)
        if isSubscribedAppleMusic {
            try await ApplicationMusicPlayer.shared.play()
        } else {
            previewPlayer?.play()
        }
    }
    
    @MainActor
    public func play() async throws {
        if isSubscribedAppleMusic {
            try await ApplicationMusicPlayer.shared.play()
        } else {
            previewPlayer?.play()
        }
    }
    
    @MainActor
    func pause() {
        if isSubscribedAppleMusic {
            ApplicationMusicPlayer.shared.pause()
        } else {
            previewPlayer?.pause()
        }
    }
    
    @MainActor
    public func seek(to time: TimeInterval) {
        if isSubscribedAppleMusic {
            ApplicationMusicPlayer.shared.playbackTime = time
        } else {
            previewPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: 600))
        }
    }
    
    @MainActor
    public func stop() {
        if isSubscribedAppleMusic {
            ApplicationMusicPlayer.shared.stop()
        } else {
            self.previewPlayer?.pause()
            self.previewPlayer = nil
        }
    }
}

