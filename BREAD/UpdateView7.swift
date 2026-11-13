//
//  Untitled.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI

struct UpdateView7: View {
    let petSize: CGFloat = 200
    let sandwichSize: CGFloat = 100
    let totalBites = 4

    @AppStorage("streakDays") private var streakDays = 1
    @AppStorage("streakPet") private var streakPet = "potato"

    @State private var bitesTaken = 0
    @State private var isChomping = false
    @State private var hasGulped = false
    @State private var petStatus = "eat"
    var sandwichLeft: CGFloat {
        CGFloat(totalBites - bitesTaken) / CGFloat(totalBites)
    }

    var body: some View {
        VStack {
            HStack {
                Image("\(streakPet) \(petStatus)")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: petSize))
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
                    .offset(x: -67 * CGFloat(bitesTaken))
            }
            Text("\(streakDays) Days")
                .font(.largeTitle)
        }
        .onAppear {
            
            feedThePotato()
        }
    }

    func feedThePotato() {
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
            petStatus = "happy"
            

            // Finished the sandwich — the streak goes up!
            streakDays += 1
        }
    }
}

#Preview {
    UpdateView7()
}
