//
//  ChooseView3.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI

struct Topping: Identifiable {
    let name: String
    let icon: String
    var rotated = false
    var id: String { name }
}

struct ChooseView3: View {
    let toppings: [Topping] = [
        Topping(name: "Lettuce", icon: "🥬"),
        Topping(name: "Tomato", icon: "🍅"),
        Topping(name: "Cheese", icon: "🧀"),
        Topping(name: "Pepperoni", icon: "🍕"),
        Topping(name: "Bacon", icon: "🥓"),
        Topping(name: "Ham", icon: "🍖"),
        Topping(name: "Chicken cutlet", icon: "🍗"),
        Topping(name: "Chicken bits", icon: "🐔"),
        Topping(name: "Cucumber", icon: "🥒"),
        Topping(name: "Pickle (cut vertically)", icon: "🥒"),
        Topping(name: "Pickle (cut horizontally)", icon: "🥒", rotated: true),
        Topping(name: "Turkey", icon: "🦃"),
        Topping(name: "Mayo", icon: "🫙"),
        Topping(name: "Beef", icon: "🥩"),
        Topping(name: "Cheese slice", icon: "🧀"),
        Topping(name: "Mozzarella cheese ball", icon: "⚪"),
        Topping(name: "Corn", icon: "🌽"),
        Topping(name: "White mushroom", icon: "🍄"),
        Topping(name: "Brown mushroom", icon: "🍄"),
        Topping(name: "Onion", icon: "🧅"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    // TODO: go back to the previous view
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // 2-by-2 grid of toppings
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16),
                ], spacing: 16) {
                    ForEach(toppings) { topping in
                        Button {
                            // TODO: open the pull-up view for this topping
                        } label: {
                            VStack(spacing: 8) {
                                // Square image with a curved border
                                Rectangle()
                                    .fill(Color(.systemGray6))
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay {
                                        Text(topping.icon)
                                            .font(.system(size: 60))
                                            .rotationEffect(.degrees(topping.rotated ? 90 : 0))
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color.secondary.opacity(0.5), lineWidth: 2)
                                    }
                                
                                Text(topping.name)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ChooseView3()
}
