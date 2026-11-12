//
//  PlatingView6.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI

struct PlatingView6: View {
    let emojiSize: CGFloat = 100
    
    @State private var topBreadOffset: CGFloat = -500
    // FEED! fades in once the top bread has landed
    @State private var isFeedButtonVisible = false
    // True after FEED! is tapped — swaps the plate out for UpdateView7
    @State private var isFeeding = false

    var body: some View {
        ZStack {
            if isFeeding {
                UpdateView7()
                    .transition(.opacity)
            } else {
                VStack(spacing: 40) {
                    VStack {
                        Text("🍞")
                            .font(.system(size: emojiSize))
                            .rotationEffect(.degrees(270))
                            .offset(y: topBreadOffset)
                        Text("🥗")
                            .font(.system(size: emojiSize))
                        Text("🍞")
                            .font(.system(size: emojiSize))
                            .rotationEffect(.degrees(90))
                        Text("🍽️")
                            .font(.system(size: emojiSize))
                    }

                    Button("FEED!") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isFeeding = true
                        }
                    }
                    .font(.title2.bold())
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .opacity(isFeedButtonVisible ? 1 : 0)
                    .scaleEffect(isFeedButtonVisible ? 1 : 0.8)
                    .disabled(!isFeedButtonVisible)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.interpolatingSpring(stiffness: 40, damping: 10).delay(0.3)) {
                topBreadOffset = 0
            }
            // Reveal FEED! just after the bread lands on the stack
            withAnimation(.easeOut(duration: 0.4).delay(1.2)) {
                isFeedButtonVisible = true
            }
        }
    }
}

#Preview {
    PlatingView6()
}
