# 🎧AppleMusicPlayer    
Make your own music player view with AMPlayer    

Full support of playback controlling    
Always on display music player like below    
<img src="https://github.com/user-attachments/assets/d80271b4-ca88-4aa4-809e-0f64f80131fc" height="320" />
<img src="https://github.com/user-attachments/assets/c1dc1f92-f015-4901-b0ce-543f2546549e" height="320" />
## ⬇️Installation
### Swift Package Manager(SPM)
Follow these steps to install *AMPlayer* using Swift Package Manager:    
 1. From within Xcode 13 or later, choose File > Swift Packages > Add Package Dependency.
 2. At the next screen, enter the URL for the AppleMusicPlayer repository in the search bar then click Next.
```bash
https://github.com/nex5turbo/AppleMusicPlayer.git
```
 3. For the Version rule, select Up to Next Minor and specify the current AppleMusicPlayer version then click Next.
 4. ON the final screen, select the AppleMusicPlayer library and then click Finish.
AppleMusicPlayer will be integrated into your project!
## Basic Usage
### Requirements
- Swift 5.5+
- iOS 16.0+
### Confguration
```swift
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
## Implementation Examples
### Basic player example
```swift
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
## AppleMusicPlayerView
## AODPlayer(Always on display player)
## EqualizerView
