import SwiftUI

struct SelectView2: View {
    @State private var hasSelected = false
    @State private var showChooseView3 = false
    
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
            
            Spacer()
            
            Button {
                hasSelected = true
            } label: {
                Text(hasSelected ? "Selected ✓" : "PEPPA PIG")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
            
            Spacer()
            
            Button {
                // TODO: start action
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
        .fullScreenCover(isPresented: $showChooseView3) {
            ChooseView3()
        }
    }
}

#Preview {
    SelectView2()
}
