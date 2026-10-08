//
//  Topic.swift
//  Amoo_generableQuiz
//
//  Created by Computer Science Swift on 10/2/26.
//


import Foundation


struct Topic: Identifiable {
    let id: UUID = UUID()
    var name: String
    var imageName: String


    static var topics: [Topic] {
        return [
            Topic(name: "Marine Life", imageName: "fish"),
            Topic(name: "Farm Animals", imageName: "hare"),
            Topic(name: "Modern Reptiles", imageName: "lizard"),
            Topic(name: "Birds of Prey", imageName: "bird")
        ]
    }
}
