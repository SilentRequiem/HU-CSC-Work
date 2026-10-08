//
//  QuestionView.swift
//  Amoo_generableQuiz
//
//  Created by Computer Science Swift on 10/2/26.
//


import SwiftUI
import FoundationModels


struct QuestionView: View {
    var question: Question.PartiallyGenerated
    @State var selectedAnswer: Answer.PartiallyGenerated?
    @State private var showConfirmation = false
    @Environment(QuizGenerator.self) private var generator


    var body: some View {
        VStack(alignment: .leading) {
            if let text = question.text {
                HStack {
                    Text(text)


                    Spacer()


                    Button {
                        showConfirmation = true
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .confirmationDialog("Regenerate question", isPresented: $showConfirmation) {
                        Button("Regenerate", role: .destructive) {
                            generator.regenerate(question: question)
                        }
                    } message: {
                        Text("Replace this question with a new one?")
                    }
                }
                .padding(.bottom, 8)
            }


            if let answers = question.answers {
                ForEach(answers) { answer in
                    AnswerView(displayAnswer: answer, selectedAnswer: $selectedAnswer)
                }
            }


            if let selectedAnswer = selectedAnswer {
                Text(selectedAnswer.explanation ?? "Generating...")
                    .font(.body.italic())
                    .padding(.top, 8)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .background(.background, in: RoundedRectangle(cornerRadius: 24.0))
    }
}


#Preview {
    QuestionView(question: Question.sample.asPartiallyGenerated())
        .environment(QuizGenerator(topic: "Marine life"))
}
