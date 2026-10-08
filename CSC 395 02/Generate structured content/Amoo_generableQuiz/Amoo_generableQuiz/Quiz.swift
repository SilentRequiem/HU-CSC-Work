//
//  Quiz.swift
//  Amoo_generableQuiz
//
//  Created by Computer Science Swift on 10/2/26.
//


import FoundationModels


@Generable
struct Quiz {
    @Guide(description: "The questions associated with this quiz.", .count(4))
    let questions: [Question]
}
