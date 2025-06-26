//
//  EqualizerView.swift
//  Readme
//
//  Created by 워뇨옹 on 6/21/25.
//

import SwiftUI

public struct EqualizerView: View {
    @State private var barHeights: [CGFloat] = [20, 40, 30]
    @State private var isAnimating = true
    
    let barCount = 3
    let maxBarHeight: CGFloat = 21
    let minBarHeight: CGFloat = 7
    let barWidth: CGFloat = 6
    let spacing: CGFloat = 4
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<barCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: barWidth / 2)
                    .frame(width: barWidth, height: barHeights[index])
                    .foregroundStyle(.white)
                    .animation(.easeInOut(duration: 0.3), value: barHeights[index])
            }
        }
        .task {
            isAnimating = true
            await startEqualizerLoop()
        }
        .onDisappear {
            isAnimating = false
        }
    }

    func startEqualizerLoop() async {
        while isAnimating {
            await MainActor.run {
                barHeights = (0..<barCount).map { _ in
                    CGFloat.random(in: minBarHeight...maxBarHeight)
                }
            }
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.3초
        }
    }
}

#Preview {
    EqualizerView()
}
