import SwiftUI


struct QuizView: View {
    @Environment(QuizGenerator.self) private var generator


    @ViewBuilder
    private var content: some View {
        let lastQuestion = generator.quiz?.questions?.last


        Color.gray.opacity(0.1)
            .edgesIgnoringSafeArea(.all)


        ScrollViewReader { value in
            ScrollView {
                quizStack
            }
            .onChange(of: lastQuestion?.answers?.count) {
                withAnimation {
                    value.scrollTo(lastQuestion?.id)
                }
            }
            .onChange(of: generator.isGenerating) {
                withAnimation {
                    value.scrollTo(generator.quiz?.questions?.first?.id)
                }
            }
        }


        if generator.isGenerating {
            HStack {
                ProgressView()
                Text("Generating...")
            }
            .frame(width: 200, height: 75)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
        }
    }


    private var quizStack: some View {
        VStack(spacing: 16) {
            if let error = generator.error {
                Label(error.localizedDescription, systemImage: "xmark.circle")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.red)
                    .padding(.horizontal)
            }


            if let questions = generator.quiz?.questions {
                ForEach(questions) { question in
                    QuestionView(question: question)
                        .disabled(generator.isGenerating)
                        .padding(.vertical, 8)
                        .id(question.id)
                }
            }


            Button {
                generator.generateQuiz()
            } label: {
                Text("Start a new quiz")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(generator.isGenerating)
        }
        .navigationTitle(generator.topic)
        .padding()
    }


    var body: some View {
        NavigationStack {
            ZStack {
                content
            }
            .onAppear {
                generator.generateQuiz()
            }
        }
    }
}


#Preview {
    QuizView()
        .environment(QuizGenerator(topic: "Marine Life"))
}
