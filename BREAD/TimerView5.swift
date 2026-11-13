//
//  TimerView5.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI
import Combine

struct TimerView5: View {

    // Ingredient picked in ChooseView3 — it drops onto the plate at zero
    var ingredient: Topping? = nil
    // Default session is one hour
    var startHours: Int = 1
    var startMinutes: Int = 0

    // PlatingView6 uses 100; scaled down here so the buttons still fit
    let emojiSize: CGFloat = 80

    @State private var hours: Int
    @State private var minutes: Int
    @State private var seconds = 0
    @State private var remainingSeconds = 0
    @State private var isRunning = false
    // Pushes PlatingView6 once the timer is marked complete
    @State private var showPlating = false

    // How far above the plate the ingredient starts
    @State private var dropOffset: CGFloat = -600
    @State private var hasDropped = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(ingredient: Topping? = nil, startHours: Int = 1, startMinutes: Int = 0) {
        self.ingredient = ingredient
        self.startHours = startHours
        self.startMinutes = startMinutes
        _hours = State(initialValue: startHours)
        _minutes = State(initialValue: startMinutes)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // Time chosen in ChooseView3, counting down live
                HStack(spacing: 10) {
                    timeUnit(hours, label: "hour")

                    Text(":")
                        .font(.system(size: 40, weight: .medium))

                    timeUnit(minutes, label: "min")

                    Text(":")
                        .font(.system(size: 40, weight: .medium))

                    // Ticks every second, so you can see it counting down
                    timeUnit(seconds, label: "sec")
                }
                .foregroundColor(.brown)
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.brown, lineWidth: 4)
                )

                // Bread stack from PlatingView6, with the chosen ingredient
                // falling onto the plate when the timer runs out
                VStack(spacing: 0) {
                    Text("🍞")
                        .font(.system(size: emojiSize))
                        .rotationEffect(.degrees(270))

                    Text("🥗")
                        .font(.system(size: emojiSize))

                    Text("🍞")
                        .font(.system(size: emojiSize))
                        .rotationEffect(.degrees(90))

                    Text("🍽️")
                        .font(.system(size: emojiSize))
                }
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottom) {
                    droppedIngredient
                        .offset(y: dropOffset)
                }

                VStack(spacing: 14) {

                    Button("Start") {
                        if remainingSeconds > 0 {
                            // Resuming after Cancel — carry on from where it stopped
                            resetDrop()
                            isRunning = true
                        } else if hours > 0 || minutes > 0 {
                            remainingSeconds = hours * 3600 + minutes * 60
                            seconds = remainingSeconds % 60
                            resetDrop()
                            isRunning = true
                        }
                    }
                    .disabled(isRunning || (remainingSeconds == 0 && hours == 0 && minutes == 0))

                    Button("Cancel") {
                        // Pause only — leave the time on screen untouched
                        isRunning = false
                    }

                    Button("Complete") {
                        isRunning = false
                        showPlating = true
                    }
                }
                .font(.title2)
                .foregroundColor(.brown)
                .buttonStyle(.bordered)
                .tint(.brown)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showPlating) {
                PlatingView6()
            }
            .onReceive(timer) { _ in
                if isRunning && remainingSeconds > 0 {
                    remainingSeconds -= 1
                    hours = remainingSeconds / 3600
                    minutes = (remainingSeconds % 3600) / 60
                    seconds = remainingSeconds % 60
                }

                if remainingSeconds == 0 {
                    if isRunning {
                        dropIngredient()
                    }
                    isRunning = false
                }
            }
        }
    }

    // One half of the timer box: the number on top, its unit label below
    private func timeUnit(_ value: Int, label: String) -> some View {
        VStack(spacing: 0) {
            Text(twoDigits(value))
                .font(.system(size: 46, weight: .semibold))
                .monospacedDigit()

            Text(label)
                .font(.subheadline)
        }
    }

    private func twoDigits(_ value: Int) -> String {
        value < 10 ? "0\(value)" : "\(value)"
    }

    // The picked topping, using its asset image where there is one
    @ViewBuilder
    private var droppedIngredient: some View {
        if let ingredient {
            if let assetName = ingredient.assetName {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .rotationEffect(.degrees(ingredient.rotated ? 90 : 0))
            } else if let icon = ingredient.icon {
                Text(icon)
                    .font(.system(size: 60))
            }
        }
    }

    private func dropIngredient() {
        guard !hasDropped else { return }
        hasDropped = true
        withAnimation(.interpolatingSpring(stiffness: 45, damping: 11)) {
            dropOffset = 0
        }
    }

    private func resetDrop() {
        hasDropped = false
        dropOffset = -600
    }
}

#Preview {
    TimerView5(ingredient: Topping(name: "Lettuce", assetName: "lettuce i"))
}
