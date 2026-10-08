//
//  Question.swift
//  Amoo_generableQuiz
//
//  Created by Computer Science Swift on 10/2/26.
//


import Foundation
import FoundationModels


@Generable()
struct Question: Identifiable {
    let id = UUID()


    @Guide(description: "A multiple-choice question on the topic that has been entered.")
    let text: String


    @Guide(description: "Answers for the multiple choice question, with only 1 of the answers being correct.", .count(4))
    let answers: [Answer]
}


extension Question {
    static let sampleAnswers = [
        Answer.correctAnswer,
        Answer.incorrectAnswer,
        Answer.incorrectAnswer,
        Answer.incorrectAnswer
    ]


    static let sample = Question(
        text: "Which answer is correct?",
        answers: sampleAnswers
    )
}
