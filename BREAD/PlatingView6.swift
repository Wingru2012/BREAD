//
//  PlatingView6.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI
import UIKit

struct PlatingView6: View {
    var ingredients: [PlanIngredient] = []

    @State private var topBreadOffset: CGFloat = -500
    @State private var isFeedButtonVisible = false
    @State private var isFeeding = false

    var body: some View {
        ZStack {
            if isFeeding {
                UpdateView7(ingredients: ingredients)
                    .transition(.opacity)
            } else {
                VStack(spacing: -40) {
                    VStack(spacing: -167) {
                        // 1. Top bread dropping down
                        Image("bread up")
                            .resizable()
                            .scaledToFit()
                            .offset(y: topBreadOffset)
                            .zIndex(3) // Drawn at the very top

                        // 2. Dropped toppings stacked on the bread
                        ZStack {
                            ForEach(ingredients) { ingredient in
                                platingIngredientView(for: ingredient)
                                    .offset(y: platingStackOffset(for: ingredient))
                            }
                        }
                        .zIndex(2) // Drawn above the bottom bread

                        // 3. Bottom bread
                        Image("bread up")
                            .resizable()
                            .scaledToFit()
                            .zIndex(1) // Drawn above the plate

                        // 4. Plate at the base
                        Image("plate")
                            .resizable()
                            .scaledToFit()
                            .zIndex(0) // Drawn at the very bottom layer
                    }
                    .padding(24)

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

            withAnimation(.easeOut(duration: 0.4).delay(1.2)) {
                isFeedButtonVisible = true
            }
        }
    }

    // MARK: - Pieces

    /// Stacking offset so toppings overlap slightly on the bread
    private func platingStackOffset(for ingredient: PlanIngredient) -> CGFloat {
        guard let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) else { return 0 }
        return -CGFloat(index) * 14
    }

    @ViewBuilder
    private func platingIngredientView(for ingredient: PlanIngredient) -> some View {
        if let assetName = platingAssetName(for: ingredient.topping) {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
        } else if let icon = ingredient.topping.icon {
            Text(icon)
                .font(.system(size: 60))
        }
    }

    /// The "s" artwork rather than the "i" selection photo
    private func platingAssetName(for topping: Topping) -> String? {
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
} // <-- Restored missing closing brace for PlatingView6 struct

#Preview {
    PlatingView6(ingredients: [
        PlanIngredient(topping: Topping(name: "Tomato", assetName: "tomato i"),
                       name: "Tomato", hours: 0, minutes: 1),
        PlanIngredient(topping: Topping(name: "Mayo", assetName: "mayo i"),
                       name: "Mayo", hours: 1, minutes: 0),
    ])
}
