import SwiftUI

struct SelectView2: View {
    @State private var ingredients: [PlanIngredient] = []
    @State private var showChooseView3 = false
    /// Ingredient whose detail sheet is currently open
    @State private var selectedIngredient: PlanIngredient?

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    // TODO: go back
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                }
                
                Spacer()
                
                Button {
                    showChooseView3 = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.bold())
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Ingredients added from ChooseView3
            ScrollView {
                if ingredients.isEmpty {
                    Text("Tap + to add an ingredient")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(ingredients) { ingredient in
                            IngredientCell(
                                ingredient: ingredient,
                                onSelect: { selectedIngredient = ingredient },
                                onDelete: { ingredients.removeAll { $0.id == ingredient.id } }
                            )
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            Button {
                // TODO: start action
            } label: {
                Text("START")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(ingredients.isEmpty ? Color.gray : Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(ingredients.isEmpty ? Color.gray : Color.accentColor, lineWidth: 4)
                    }
            }
            .disabled(ingredients.isEmpty)
            .padding()
        }
        .fullScreenCover(isPresented: $showChooseView3) {
            ChooseView3 { ingredient in
                ingredients.append(ingredient)
            }
        }
        .sheet(item: $selectedIngredient) { ingredient in
            // Bind straight into the array so edits show up in the grid instantly
            if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                IngredientDetailSheet(ingredient: $ingredients[index])
            }
        }
    }
}

/// One added ingredient: the picture plus the name typed in ChooseView3.
struct IngredientCell: View {
    let ingredient: PlanIngredient
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.white)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        if let assetName = ingredient.topping.assetName {
                            Image(assetName)
                                .resizable()
                                .scaledToFit()
                                .padding(16)
                                .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
                        } else if let icon = ingredient.topping.icon {
                            Text(icon)
                                .font(.system(size: 60))
                                .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.secondary.opacity(0.5), lineWidth: 2)
                    }
                
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(Color.brown))
                }
                .padding(6)
            }
            
            Text(ingredient.name)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
        }
        .contentShape(Rectangle())
        // Tapping the cell opens the detail sheet; the X button above still wins
        .onTapGesture(perform: onSelect)
    }
}

/// Detail sheet for an added ingredient: picture on the left, editable name
/// and study time on the right. Edits update the ingredient in SelectView2.
struct IngredientDetailSheet: View {
    @Binding var ingredient: PlanIngredient

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // Ingredient picture
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.secondary.opacity(0.6), lineWidth: 3)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let assetName = ingredient.topping.assetName {
                        Image(assetName)
                            .resizable()
                            .scaledToFit()
                            .padding(16)
                            .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
                    } else if let icon = ingredient.topping.icon {
                        Text(icon)
                            .font(.system(size: 60))
                            .rotationEffect(.degrees(ingredient.topping.rotated ? 90 : 0))
                    }
                }
                .frame(maxWidth: .infinity)

            VStack(spacing: 16) {
                // Name (editable, updates the grid instantly)
                TextField(
                    "",
                    text: $ingredient.name,
                    prompt: Text("name").foregroundStyle(.gray)
                )
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.vertical, 18)
                .padding(.horizontal, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.secondary.opacity(0.6), lineWidth: 3)
                }

                // Study time: XX h : XX m
                HStack(spacing: 6) {
                    Picker("Hours", selection: $ingredient.hours) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text("\(hour) h").tag(hour)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .fixedSize()

                    Text(":")
                        .font(.title3.bold())
                        .foregroundStyle(.primary)

                    Picker("Minutes", selection: $ingredient.minutes) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text("\(minute) m").tag(minute)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .fixedSize()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.secondary.opacity(0.6), lineWidth: 3)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .presentationBackground(.white)
        .presentationDetents([.fraction(0.4), .medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    SelectView2()
}
