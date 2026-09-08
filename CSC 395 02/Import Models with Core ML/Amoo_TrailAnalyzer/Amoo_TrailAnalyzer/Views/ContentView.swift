import SwiftUI


struct ContentView: View {
    @State private var trailInfo = TrailInfo()


    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text("Enter the data about your upcoming hike")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                }
                .padding(.bottom)


                TrailInfoView(trailInfo: $trailInfo)


                NavigationLink {
                    let analyzer = TrailAnalyzer()
                    let risk = analyzer.predictRisk(trailInfo: trailInfo)
                    PredictionView(predictedRisk: risk)
                } label: {
                    Text("Submit")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            .tint,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .foregroundStyle(.white)
                }
            }
            .navigationTitle("Trail Analyzer")
            .scrollDismissesKeyboard(.interactively)
            .trailTheme()
        }
        .tint(Color.trailTheme)
        .onAppear {
            trailInfo = .sample
        }
    }
}


#Preview {
    ContentView()
}
