//
//  SelectView2.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//
import SwiftUI

struct SelectView2: View {
    @State private var hasSelected = false
    
    var body: some View {
        VStack {
            // Top bar: "<-" on the left, "+" on the right
            HStack {
                Button {
                    // TODO: go back
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                }
                
                Spacer()
                
                Button {
                    // TODO: add new
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.bold())
                        .frame(width: 44, height: 44)
                        .overlay {
                            Circle()
                                .strokeBorder(Color.primary, lineWidth: 3)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            // Placeholder selection: replace with your real selection UI.
            // Tapping it marks a selection as made, which enables START.
            Button {
                hasSelected = true
            } label: {
                Text(hasSelected ? "Selected ✓" : "Tap to select a bread")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
            
            Spacer()
            
            // START: grey and disabled until hasSelected is true
            Button {
                // TODO: start
            } label: {
                Text("START")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(hasSelected ? Color.accentColor : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(hasSelected ? Color.accentColor : Color.gray, lineWidth: 4)
                    }
            }
            .disabled(!hasSelected)
            .padding()
        }
    }
}

#Preview {
    SelectView2()
}


