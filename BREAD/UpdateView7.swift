//
//  Untitled.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI
import UIKit

struct UpdateView7: View {
    let petSize: CGFloat = 200
    let sandwichSize: CGFloat = 100
    let totalBites = 4
    var ingredients: [PlanIngredient] = []

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
                
                sandwichStack
                    .frame(width: sandwichSize, height: sandwichSize)
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

    // MARK: - Sandwich

    @ViewBuilder
    private var sandwichStack: some View {
        VStack(spacing: -23) {
            Image("bread up")
                .resizable()
                .scaledToFit()
                .zIndex(3)

            ZStack {
                ForEach(ingredients) { ingredient in
                    updateIngredientView(for: ingredient)
                        .offset(y: updateStackOffset(for: ingredient))
                        .zIndex(2)
                }
            }

            Image("bread up")
                .resizable()
                .scaledToFit()
                .zIndex(1)

            Image("plate")
                .resizable()
                .scaledToFit()
                .offset(y: -25)
                .zIndex(0)
        }
    }

    private func updateStackOffset(for ingredient: PlanIngredient) -> CGFloat {
        guard let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) else { return 0 }
        return -CGFloat(index) * 14 
    }

    @ViewBuilder
    private func updateIngredientView(for ingredient: PlanIngredient) -> some View {
        if let assetName = updateAssetName(for: ingredient.topping) {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: sandwichSize * 0.6, height: sandwichSize * 0.6)
                .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
        } else if let icon = ingredient.topping.icon {
            Text(icon)
                .font(.system(size: sandwichSize * 0.4))
        }
    }

    private func updateAssetName(for topping: Topping) -> String? {
        guard let name = topping.assetName else { return nil }
        guard name.hasSuffix(" i") else { return name }

        let smallName = String(name.dropLast(2)) + " s"
        if UIImage(named: smallName) != nil {
            return smallName
        }
        if UIImage(named: smallName + " ") != nil {
            return smallName + " "
        }
        return name
    }
}

#Preview {
    UpdateView7()
}
