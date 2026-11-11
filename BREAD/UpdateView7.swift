//
//  Untitled.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI

struct UpdateView7: View {
    let potatoSize: CGFloat = 200
    let sandwichSize: CGFloat = 100
    let totalBites = 4


    @State private var bitesTaken = 0
    @State private var isChomping = false
    @State private var hasGulped = false
    @State private var isEating = false

    var sandwichLeft: CGFloat {
        CGFloat(totalBites - bitesTaken) / CGFloat(totalBites)
    }

    var body: some View {
        VStack(spacing: 60) {
            HStack {
                Text("🥔")
                    .font(.system(size: potatoSize))
                    .scaleEffect(x: isChomping ? 1.15 : 1,
                                 y: isChomping ? 0.75 : 1,
                                 anchor: .bottom)
                    .scaleEffect(hasGulped ? 1.15 : 1)
                    .offset(x: isChomping ? 14 : 0)

                Text("🥪")
                    .font(.system(size: sandwichSize))
                    .mask {
                        Rectangle()
                            .scaleEffect(x: sandwichLeft, anchor: .trailing)
                    }
                    .offset(x: -16 * CGFloat(bitesTaken))
            }

            Button("FEED!") {
                feedThePotato()
            }
            .font(.title2.bold())
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .disabled(isEating)
        }
    }

    func feedThePotato() {
        if bitesTaken >= totalBites {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                bitesTaken = 0
                hasGulped = false
            }
            return
        }

        isEating = true

        Task {
            for _ in 0..<(totalBites - bitesTaken) {
                withAnimation(.easeIn(duration: 0.15)) { isChomping = true }
                try? await Task.sleep(for: .milliseconds(150))
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    bitesTaken += 1
                }
                withAnimation(.easeOut(duration: 0.15)) { isChomping = false }
                try? await Task.sleep(for: .milliseconds(400))
            }

            withAnimation(.interpolatingSpring(stiffness: 120, damping: 6)) {
                hasGulped = true
            }

            isEating = false
        }
    }
}

#Preview {
    UpdateView7()
}
