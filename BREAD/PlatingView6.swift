//
//  PlatingView6.swift
//  BREAD
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI

struct PlatingView6: View {
    let emojiSize: CGFloat = 100
    
    @State private var topBreadOffset: CGFloat = -500

    var body: some View {
        VStack {
            Text("🍞")
                .font(.system(size: emojiSize))
                .rotationEffect(.degrees(270))
                .offset(y: topBreadOffset)
            Text("🥗")
                .font(.system(size: emojiSize))
            Text("🍞")
                .font(.system(size: emojiSize))
                .rotationEffect(.degrees(90))
            Text("🍽️")
                .font(.system(size: emojiSize))
        }
        .onAppear {

            withAnimation(.interpolatingSpring(stiffness: 40, damping: 10).delay(0.3)) {
                topBreadOffset = 0
            }
        }
    }
}

#Preview {
    PlatingView6()
}
