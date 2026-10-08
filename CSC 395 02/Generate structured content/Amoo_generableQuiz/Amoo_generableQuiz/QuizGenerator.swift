//
//  QuizGenerator.swift
//  Amoo_generableQuiz
//
//  Created by Computer Science Swift on 10/2/26.
//


import SwiftUI
import FoundationModels


@Observable
class QuizGenerator {
    let topic: String
    var quiz: Quiz.PartiallyGenerated?
    var isGenerating = false
    var error: Error?


    init(topic: String) {
        self.topic = topic
    }


    func generateQuiz() {
        let session = LanguageModelSession(instructions: "Create a quiz with the provided topic as the focus.")
        let stream = session.streamResponse(to: topic, generating: Quiz.self)


        run {
            for try await partial in stream {
                withAnimation {
                    self.quiz = partial.content
                }
            }
        }
    }


    func regenerate(question: Question.PartiallyGenerated) {
        guard !isGenerating,
              var quiz = self.quiz,
              let questions = quiz.questions,
              let index = questions.firstIndex(where: { $0.id == question.id }) else {
            return
        }


        let session = LanguageModelSession(instructions: "Create a question focused on \(topic)")
        let existingQuestions = questions.compactMap { $0.text }.joined(separator: ", ")
        let prompt = "Avoid asking questions similar to these: \(existingQuestions)"
        let stream = session.streamResponse(to: prompt, generating: Question.self)


        run {
            for try await partial in stream {
                withAnimation {
                    quiz.questions?[index] = partial.content
                    self.quiz = quiz
                }
            }
        }
    }


    func run(session: @escaping () async throws -> Void) {
        Task {
            withAnimation {
                isGenerating = true
            }


            error = nil
            do {
                try await session()
            } catch {
                self.error = error
            }


            isGenerating = false
        }
    }
}
