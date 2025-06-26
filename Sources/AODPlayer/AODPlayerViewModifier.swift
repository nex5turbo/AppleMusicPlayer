//
//  AODPlayerViewModifier.swift
//  AppleMusicPlayer
//
//  Created by 워뇨옹 on 6/26/25.
//

import SwiftUI

public struct AODPlayerViewModifier<MiniPlayer: View, FullScreenPlayer: View>: ViewModifier {
    @State private var isFullScreenPlayerPresented: Bool = false
    let miniPlayer: () -> MiniPlayer
    let fullScreenPlayer: (() -> FullScreenPlayer)?

    public func body(content: Content) -> some View {
        content
            .overlay {
                VStack {
                    Spacer()
                    miniPlayer()
                        .onTapGesture {
                            if fullScreenPlayer != nil {
                                isFullScreenPlayerPresented.toggle()
                            }
                        }
                }
            }
            .fullScreenCover(isPresented: $isFullScreenPlayerPresented) {
                if let fullScreenPlayer = fullScreenPlayer {
                    fullScreenPlayer()
                }
            }
    }
}

public extension View {
    func aodPlayer<MiniPlayer: View, FullScreenPlayer: View>(
        @ViewBuilder miniPlayer: @escaping () -> MiniPlayer,
        @ViewBuilder fullScreenPlayer: @escaping (() -> FullScreenPlayer)?
    ) -> some View {
        self.modifier(AODPlayerViewModifier(miniPlayer: miniPlayer, fullScreenPlayer: fullScreenPlayer))
    }
}
