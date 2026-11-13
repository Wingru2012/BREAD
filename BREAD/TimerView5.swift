//
//  TimerView5.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI
import Combine

struct TimerView5: View {

    @State private var hours = 0
    @State private var minutes = 0
    @State private var remainingSeconds = 0
    @State private var isRunning = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Text("hour")
                Text(":")
                Text("min")
            }
            .font(.system(size: 36, weight: .medium))
            .foregroundColor(.brown)
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.brown, lineWidth: 4)
            )

            ZStack {
                Image("FoodDrops")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Image("Plate")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 90)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 360)

            VStack(spacing: 14) {

                Button("Start") {
                    if hours > 0 || minutes > 0 {
                        remainingSeconds = hours * 3600 + minutes * 60
                        isRunning = true
                    }
                }
                .disabled(isRunning || (hours == 0 && minutes == 0))

                Button("Cancel") {
                    isRunning = false
                    remainingSeconds = 0
                    hours = 0
                    minutes = 0
                }

                Button("Complete") {
                    isRunning = false
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
        .onReceive(timer) { _ in
            if isRunning && remainingSeconds > 0 {
                remainingSeconds -= 1
                hours = remainingSeconds / 3600
                minutes = (remainingSeconds % 3600) / 60
            }

            if remainingSeconds == 0 {
                isRunning = false
            }
        }
    }
}

#Preview {
    TimerView5()
}

