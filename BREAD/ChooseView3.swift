//
//  ChooseView3.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI

struct Topping: Identifiable {
    let name: String
    var icon: String? = nil
    var assetName: String? = nil
    var rotated = false
    var id: String { name }
}

struct ChooseView3: View {
    @Environment(\.dismiss) private var dismiss

    let toppings: [Topping] = [
        Topping(name: "Lettuce", assetName: "lettuce i"),
        Topping(name: "Tomato", assetName: "tomato i"),
        Topping(name: "Cheese", assetName: "cheese i"),
        Topping(name: "Salami", assetName: "salami i"),
        Topping(name: "Bacon", assetName: "bacon i"),
        Topping(name: "Ham", assetName: "ham i"),
        Topping(name: "Chicken cutlet", assetName: "chicken cutlet i"),
        Topping(name: "Chicken bits", assetName: "chicken bits i"),
        Topping(name: "Cucumber", assetName: "cucumber i"),
        Topping(name: "Pickle (cut vertically)", assetName: "Pickle (cut vertically) i"),
        Topping(name: "Pickle (cut horizontally)", assetName:"Pickle (cut horizontally) i"),
        Topping(name: "Turkey", assetName: "turkey i"),
        Topping(name: "Mayo", assetName: "mayo i"),
        Topping(name: "Beef", assetName: "beef i"),
        Topping(name: "Cheese slice", assetName: "cheese slice i"),
        Topping(name: "Mozzarella cheese ball", assetName: "Mozzarella cheese ball i"),
        Topping(name: "Corn", assetName: "corn i"),
        Topping(name: "White mushroom", assetName: "white mushroom i"),
        Topping(name: "Brown mushroom", assetName: "brown mushroom i"),
        Topping(name: "Onion", assetName: "onion i"),
    ]
    
    @State private var selectedTopping: Topping?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
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
                            selectedTopping = topping
                        } label: {
                            VStack(spacing: 8) {
                                // Square image with a curved border
                                Rectangle()
                                    .fill(Color.white)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay {
                                        if let assetName = topping.assetName {
                                            Image(assetName)
                                                .resizable()
                                                .scaledToFit()
                                                .padding(16)
                                                .rotationEffect(.degrees(topping.rotated ? 90 : 0))
                                        } else if let icon = topping.icon {
                                            Text(icon)
                                                .font(.system(size: 60))
                                                .rotationEffect(.degrees(topping.rotated ? 90 : 0))
                                        }
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
        .sheet(item: $selectedTopping) { topping in
            ToppingDetailSheet(topping: topping)
        }
    }
}

struct ToppingDetailSheet: View {
    let topping: Topping
    @Environment(\.dismiss) private var dismiss

    @State private var nameInput: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // Main content: Image + bold name on left, native inputs on right
            HStack(alignment: .center, spacing: 16) {
                // Left side: Topping image with bold ingredient name underneath
                VStack(spacing: 8) {
                    if let assetName = topping.assetName {
                        Image(assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .rotationEffect(.degrees(topping.rotated ? 90 : 0))
                    } else if let icon = topping.icon {
                        Text(icon)
                            .font(.system(size: 72))
                            .rotationEffect(.degrees(topping.rotated ? 90 : 0))
                    }

                    Text(topping.name)
                        .font(.headline.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)

                // Right side: Native Apple inputs on white sheet
                VStack(spacing: 12) {
                    // Native iOS TextField with grey "type here" placeholder
                    TextField(
                        "",
                        text: $nameInput,
                        prompt: Text("type here").foregroundStyle(.gray)
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    // Native iOS Duration Picker (h : m)
                    HStack(spacing: 4) {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour)").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 50, height: 80)
                        .clipped()

                        Text("h")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)

                        Text(":")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 2)

                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute)").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 50, height: 80)
                        .clipped()

                        Text("m")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)

            Spacer()

            // Native Apple prominent pill button
            Button {
                // TODO: save nameInput, hours, minutes and add topping
                dismiss()
            } label: {
                Text("Add")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .presentationBackground(.white)
        .presentationDetents([.fraction(0.45), .medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    ChooseView3()
}

