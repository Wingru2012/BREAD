// homepage

import SwiftUI

struct StreakPetView: View {
    let potatosize: CGFloat = 200
    
    @AppStorage("streakDays") private var streakDays = 1
    @AppStorage("streakPet") private var streakPet = "potato normal"

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                ZStack {
                    Image("\(streakPet)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 1000)
                        .offset(x: 30)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 450)

                Text("🔥\(streakDays)")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(.black)

                NavigationLink(destination: SelectView2()) {
                    Text("Start Plan")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.blue)
                        .cornerRadius(35)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
}

#Preview {
    StreakPetView()
}





//2
