import SwiftUI


struct ContentView: View {
    @Environment(AppManager.self) private var appManager


    var body: some View {
        VStack {
            if appManager.showKitchen {
                KitchenView()
            } else {
                StartView()
            }
        }
        .frame(minWidth: ImageGenerator.imageSize, maxWidth: 400, minHeight: 550)
        .overlay {
            if appManager.isGenerating {
                loadingView()
            }
        }
    }


    private func loadingView() -> some View {
        HStack(spacing: 8) {
            ProgressView()
            Text("Generating image...")
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}


#Preview {
    ContentView()
        .previewEnvironment(generateImage: false)
}
