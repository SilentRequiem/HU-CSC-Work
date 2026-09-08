import SwiftUI


struct TrailTheme: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            VStack {
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                Spacer()
            }
            content
                .padding(.horizontal)
        }
        .background(Color(white: 0.94))
    }
}


extension View {
    func trailTheme() -> some View {
        modifier(TrailTheme())
    }
}


extension Color {
    static var trailTheme: Color {
        Color(red: 0.92, green: 0.32, blue: 0.25)
    }
}


#Preview {
    Text("Hello, World!")
        .trailTheme()
}
