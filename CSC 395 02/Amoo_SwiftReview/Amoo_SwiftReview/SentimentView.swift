//
//  SentimentView.swift
//  Amoo_SwiftReview
//
//  Created by Computer Science Swift on 9/5/26.
//

import SwiftUI
import NaturalLanguage

struct SentimentView: View {
    @State private var inputText = ""
    @State private var result = "No result yet"

    var body: some View {
        Form {
            Section("Reflection") {
                TextEditor(text: $inputText)
                    .frame(minHeight: 120)
            }

            Section {
                Button("Analyze Sentiment") {
                    analyzeSentiment()
                }
            }

            Section("Result") {
                Text(result)
            }
        }
        .navigationTitle("Sentiment")
    }

    func analyzeSentiment() {
        if inputText.isEmpty {
            result = "Enter some text first."
            return
        }

        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = inputText

        let sentiment = tagger.tag(
            at: inputText.startIndex,
            unit: .paragraph,
            scheme: .sentimentScore
        )

        if let score = sentiment.0?.rawValue {
            result = "Sentiment Score: \(score)"
        }
    }
}
