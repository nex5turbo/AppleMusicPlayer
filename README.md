# AppleMusicPlayer    
AppleMusicPlayer is music player kit using Swift MusicKit.    
Since playing song with MusicKit seperates preview and full music by whether user is subscribing apple music or not, we need to seperate all codes when we want to play music.    
This is why AppleMusicPlayer came out. Put song into AppleMusicPlayer and it will automatically check users' subscribing status and play proper way.    

AppleMusicPlayer also provide fully customizable playback controller UI.    
## Basic Usage
### Declare AppleMusicPlayer at ContentView
```
import SwiftUI
import AppleMusicPlayer

struct ContentView: View {
    @StateObject private var appleMusicPlayer = AppleMusicPlayer()
    var body: some View {
        SomeView()
          .environmentObject(appleMusicPlayer)
          .task {
              await appleMusicPlayer.authorize() // Request Apple Music usage permission
              try? await appleMusicPlayer.checkSubscriptionStatus() // check whether user subscribed apple music or not. Always play preview if you don't check this.
          }
    }
}
```
### Make view wherever you want
```
import SwiftUI
import AppleMusicPlayer

struct MainView: View {
  @EnvironmentObject private var appleMusicPlayer: AppleMusicPlayer
  var body: some View {
    VStack {
      AppleMusicPlayerView(musicPlayer: appleMusicPlayer) {
        HStack {
          Button {
            if appleMusicPlayer.isPlaying {
              appleMusicPlayer.pause()
            } else {
              appleMusicPlayer.play()
            }
          } label: {
            Image(systemName: "play.fill")
          }
        }
      }
    }
  }
}
```

## AppleMusicPlayer    
### State variables(Read-only)    
```
status: MusicAuthorization.Status
isSubscribedAppleMusic: Bool

isPlaying: Bool
currentSong: Song?
currentSongDuration: TimeInterval
var currentSongPlaybackTime: TimeInterval
```
### Functions
```
authorize() async
checkSubscriptionStatus() async throws
setup(with song: Song) async throws
play(song: Song) asnyc throws
play() async throws
pause()
seek(to time: TimeInterval
stop()
```
## AppleMusicPlayerView
## AODPlayer(Always on display player)
## EqualizerView
