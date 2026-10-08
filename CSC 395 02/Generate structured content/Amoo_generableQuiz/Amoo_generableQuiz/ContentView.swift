import SwiftUI
import FoundationModels


struct ContentView: View {
    private var topicSelectionView: some View {
        VStack(spacing: 16) {
            Text("Pick a topic for your quiz")
                .font(.title)


            ForEach(Topic.topics) { topic in
                NavigationLink {
                    QuizView()
                        .environment(QuizGenerator(topic: topic.name))
                } label: {
                    HStack {
                        Image(systemName: topic.imageName)
                        Text(topic.name)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(.borderedProminent)
            }


            Spacer()
        }
        .padding()
    }


    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)


                switch SystemLanguageModel.default.availability {
                case .available:
                    topicSelectionView
                case .unavailable(let unavailableReason):
                    UnavailableView(reason: unavailableReason)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
