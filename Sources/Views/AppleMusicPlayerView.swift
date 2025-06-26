//
//  AppleMusicPlayerView.swift
//  AppleMusicPlayer
//
//  Created by 워뇨옹 on 6/26/25.
//

import SwiftUI

public struct AppleMusicPlayerView<Content: View>: View {
    @ObservedObject private var musicPlayer: AppleMusicPlayer
    private let content: () -> Content
    
    public init(
        musicPlayer: AppleMusicPlayer,
        content: Content
    ) {
        self._musicPlayer = ObservedObject(wrappedValue: musicPlayer)
        self.content = content
        
        self.musicPlayer.referrenceCount += 1
    }
    
    public var body: some View {
        content()
            .onReceive(musicPlayer.timer) { _ in
                updateProgress()
            }
            .onDisappear {
                self.musicPlayer.referrenceCount -= 1
                if musicPlayer.referrenceCount <= 0 {
                    self.musicPlayer.timer.upstream.connect().cancel()
                    self.musicPlayer.timer = nil
                }
            }
            .onAppear {
                guard musicPlayer.timer == nil else {
                    return
                }
                self.musicPlayer.timer = Timer.publish(every: 0.1, on: .main, in: .common)
                    .autoconnect()
            }
    }
    
    private func updateProgress() {
        self.musicPlayer.currentSongPlaybackTime = self.musicPlayer.playbackTime
        self.musicPlayer.isPlaying = self.musicPlayer.checkIsPlaying()
    }
}

#Preview {
    AppleMusicPlayerView { controller in
        
    }
}
