//
//  TimerView5.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI
import Combine
import UIKit

/// Countdown state for one ingredient
private struct IngredientTimer {
    var remaining: Int
    var isRunning = false
    var hasDropped = false
    var dropOffset: CGFloat = -100
}

struct TimerView5: View {
    
    // Returns to the ingredient selection screen
    @Environment(\.dismiss) private var dismiss
    
    /// Every ingredient added in SelectView2 — one tab each
    var ingredients: [PlanIngredient]
    
    // PlatingView6 uses 100; scaled down here so the buttons still fit
    let emojiSize: CGFloat = 80
    /// Vertical gap between stacked ingredients — small enough that each one
    /// covers part of the ingredient below without hiding it completely
    let stackSpacing: CGFloat = 14
    /// How far each bread layer is pushed down to overlap the one below
    let breadOverlap: CGFloat = 140
    /// How far the bottom bread drops onto the plate so they overlap
    let breadPlateOverlap: CGFloat = 30
    /// How far up ingredients land so they sit on top of the bread
    let ingredientBaseOffset: CGFloat = 25
    
    @State private var selectedID: UUID
    /// One countdown per ingredient, so tabs keep their own time
    @State private var timers: [UUID: IngredientTimer] = [:]
    /// Order in which finished ingredients landed on the sandwich
    @State private var droppedOrder: [UUID] = []
    /// Whether the ingredient tab strip is unfolded
    @State private var isTabsExpanded = true
    // Pushes PlatingView6 once the timer is marked complete
    @State private var showPlating = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(ingredients: [PlanIngredient]) {
        self.ingredients = ingredients
        _selectedID = State(initialValue: ingredients.first?.id ?? UUID())
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                // Top bar: tab toggle on the left, back button next to it
                // Top bar: blue Liquid Glass buttons
                HStack(spacing: 12) {
                    // Folds / unfolds the ingredient tab strip
                    Button {
                        withAnimation(.easeInOut(duration: 0.22)) {
                            isTabsExpanded.toggle()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: isTabsExpanded ? "chevron.left" : "list.bullet")
                                .font(.footnote.bold())
                            
                            Text("\(ingredients.count)")
                                .font(.footnote.bold())
                                .monospacedDigit()
                        }
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 14)
                        .frame(height: 40)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay {
                            Capsule()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [.white.opacity(0.85), .blue.opacity(0.25)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        }
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                        .contentShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    
                    // Back to SelectView2 — blocked while any timer is running
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.body.bold())
                            .foregroundStyle(.blue)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial, in: Circle())
                            .overlay {
                                Circle()
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [.white.opacity(0.85), .blue.opacity(0.25)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            }
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(anyTimerRunning)
                    .opacity(anyTimerRunning ? 0.35 : 1)
                    
                    Spacer()
                }
                HStack(alignment: .top, spacing: 12) {
                    
                    if isTabsExpanded {
                        ingredientTabs
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    VStack(spacing: 16) {
                        
                        // Time for the selected ingredient, counting down live
                        HStack(spacing: 10) {
                            timeUnit(hours, label: "hour")
                            
                            Text(":")
                                .font(.system(size: 40, weight: .medium))
                            
                            timeUnit(minutes, label: "min")
                            
                            Text(":")
                                .font(.system(size: 40, weight: .medium))
                            
                            timeUnit(seconds, label: "sec")
                        }
                        .foregroundColor(.brown)
                        .frame(maxWidth: .infinity)
                        .frame(height: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.brown, lineWidth: 4)
                        )
                        .padding()
                        Spacer()
                        Spacer()
                        // Bread stack from PlatingView6 — finished ingredients
                        // drop onto the plate and stack up
                        VStack(spacing: -120) {
                            
                            Image("bread up")
                                .resizable()
                                .scaledToFit()
                                .zIndex(1)
                            
                            Image("plate")
                                .resizable()
                                .scaledToFit()
                                .zIndex(0)
                        }
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .bottom) {
                            // Every finished ingredient lands here, stacked
                            ZStack {
                                ForEach(droppedIngredients) { ingredient in
                                    ingredientView(for: ingredient)
                                        .offset(y: totalDropOffset(for: ingredient))
                                }
                            }
                        }
                        
                        VStack(spacing: 14) {
                            
                            Button("Start") {
                                startSelected()
                            }
                            .disabled(selectedState.isRunning || selectedState.remaining == 0)
                            
                            Button("Cancel") {
                                // Pause only — leave the time on screen untouched
                                updateSelected { $0.isRunning = false }
                            }
                            
                            // Grey until every ingredient's timer has run out,
                            // then it turns blue and can be tapped
                            Button {
                                showPlating = true
                            } label: {
                                Text("Complete")
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, minHeight: 64)
                                    .background(allTimersFinished ? Color.blue : Color.gray)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                            .disabled(!allTimersFinished)
                        }
                        .font(.title2)
                        .foregroundColor(.brown)
                        .buttonStyle(.bordered)
                        .tint(.brown)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showPlating) {
                PlatingView6(ingredients: droppedIngredients)
            }
            .onReceive(timer) { _ in
                tick()
            }
        }
    }
    
    // MARK: - Tabs
    
    /// Vertical tab per added ingredient, showing its own countdown
    private var ingredientTabs: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(ingredients) { ingredient in
                    let state = state(for: ingredient.id)
                    let isSelected = ingredient.id == selectedID
                    
                    Button {
                        select(ingredient.id)
                    } label: {
                        VStack(spacing: 4) {
                            tabImage(for: ingredient)
                                .frame(width: 52, height: 52)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isSelected ? Color.brown : Color.gray.opacity(0.4),
                                                lineWidth: isSelected ? 3 : 2)
                                }
                            
                            Text(shortTime(state.remaining))
                                .font(.caption2)
                                .monospacedDigit()
                                .foregroundColor(state.remaining == 0 ? .gray : .brown)
                        }
                        .padding(4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
        .frame(width: 72)
    }
    
    @ViewBuilder
    private func tabImage(for ingredient: PlanIngredient) -> some View {
        if let assetName = ingredient.topping.assetName {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .padding(6)
                .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
        } else if let icon = ingredient.topping.icon {
            Text(icon)
                .font(.system(size: 30))
                .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
        }
    }
    
    // MARK: - Timers
    
    private var selectedState: IngredientTimer {
        state(for: selectedID)
    }
    
    /// Ingredients whose timers have run out, in the order they landed
    private var droppedIngredients: [PlanIngredient] {
        droppedOrder.compactMap { id in ingredients.first { $0.id == id } }
    }
    
    private var anyTimerRunning: Bool {
        ingredients.contains { state(for: $0.id).isRunning }
    }
    
    /// True once every ingredient's countdown has reached zero
    private var allTimersFinished: Bool {
        !ingredients.isEmpty && ingredients.allSatisfy { state(for: $0.id).remaining == 0 }
    }
    
    // Numbers shown in the big box
    private var hours: Int { selectedState.remaining / 3600 }
    private var minutes: Int { (selectedState.remaining % 3600) / 60 }
    private var seconds: Int { selectedState.remaining % 60 }
    
    private func duration(of ingredient: PlanIngredient?) -> Int {
        guard let ingredient else { return 0 }
        return ingredient.hours * 3600 + ingredient.minutes * 60
    }
    
    /// Stored state, or a fresh one seeded with the ingredient's chosen time
    private func state(for id: UUID) -> IngredientTimer {
        if let stored = timers[id] {
            return stored
        }
        return IngredientTimer(remaining: duration(of: ingredients.first { $0.id == id }))
    }
    
    private func updateSelected(_ change: (inout IngredientTimer) -> Void) {
        var state = selectedState
        change(&state)
        timers[selectedID] = state
    }
    
    private func startSelected() {
        updateSelected { state in
            state.hasDropped = false
            state.dropOffset = -600
            state.isRunning = true
        }
        // No longer sitting on the sandwich
        droppedOrder.removeAll { $0 == selectedID }
    }
    
    private func select(_ id: UUID) {
        selectedID = id
        // A tab that already finished shows its ingredient sitting on the plate
        if var state = timers[id], state.hasDropped, state.dropOffset != 0 {
            state.dropOffset = 0
            timers[id] = state
        }
    }
    
    private func tick() {
        var finished: [UUID] = []
        
        for ingredient in ingredients {
            var state = state(for: ingredient.id)
            guard state.isRunning, state.remaining > 0 else { continue }
            
            state.remaining -= 1
            
            if state.remaining == 0 {
                state.isRunning = false
                state.hasDropped = true
                finished.append(ingredient.id)
            }
            
            timers[ingredient.id] = state
        }
        
        guard !finished.isEmpty else { return }
        
        // Remember the landing order for stacking, then drop every finished
        // ingredient onto the sandwich — including ones on other tabs
        droppedOrder.append(contentsOf: finished)
        
        withAnimation(.interpolatingSpring(stiffness: 45, damping: 11)) {
            for id in finished {
                timers[id]?.dropOffset = 0
            }
        }
    }
    
    // MARK: - Pieces
    
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
    
    private func shortTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes):" + (seconds < 10 ? "0\(seconds)" : "\(seconds)")
    }
    
    /// Where a dropped ingredient sits in the stack: each one a little
    /// higher than the last, so they overlap but stay partly visible
    private func stackOffset(for ingredient: PlanIngredient) -> CGFloat {
        guard let index = droppedOrder.firstIndex(of: ingredient.id) else { return 0 }
        return -CGFloat(index) * stackSpacing
    }
    
    /// Drop animation (from above) plus the ingredient's stacking position
    private func totalDropOffset(for ingredient: PlanIngredient) -> CGFloat {
        (timers[ingredient.id]?.dropOffset ?? 0) + stackOffset(for: ingredient) - ingredientBaseOffset - 10
    }
    
    /// One ingredient's artwork, using the "s" plating asset where there is one
    @ViewBuilder
    private func ingredientView(for ingredient: PlanIngredient) -> some View {
        if let assetName = dropAssetName(for: ingredient.topping) {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
        } else if let icon = ingredient.topping.icon {
            Text(icon)
                .font(.system(size: 60))
        }
    }
    
    /// The "s" artwork (e.g. "tomato s") rather than the "i" selection photo
    /// ("tomato i") that ChooseView3 uses.
    private func dropAssetName(for topping: Topping) -> String? {
        guard let name = topping.assetName else { return nil }
        guard name.hasSuffix(" i") else { return name }
        
        let smallName = String(name.dropLast(2)) + " s"
        if UIImage(named: smallName) != nil {
            return smallName
        }
        // The tomato artwork is stored as "tomato s " with a trailing space
        if UIImage(named: smallName + " ") != nil {
            return smallName + " "
        }
        // No dropping artwork for this topping: reuse the selection photo
        return name
    }
}

#Preview {
    TimerView5(ingredients: [
        PlanIngredient(topping: Topping(name: "Tomato", assetName: "tomato i"),
                       name: "Tomato", hours: 0, minutes: 1),
        PlanIngredient(topping: Topping(name: "Mayo", assetName: "mayo i"),
                       name: "Mayo", hours: 1, minutes: 0),
        PlanIngredient(topping: Topping(name: "Turkey", assetName: "turkey i"),
                       name: "Turkey", hours: 0, minutes: 30)
    ])
}
