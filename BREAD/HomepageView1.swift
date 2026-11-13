
import SwiftUI

struct StreakPetView: View {
    @State private var streakDays = 1

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                ZStack {
                    Image("StreakPet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 450)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 450)

                Text("\(streakDays) days")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(.brown)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.brown, lineWidth: 4)
                    )

                NavigationLink(destination: SelectView2()) {
                    Text("Start Plan")
                        .font(.title3)
                        .foregroundColor(.brown)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 35)
                                .stroke(Color.brown, lineWidth: 5)
                        )
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
