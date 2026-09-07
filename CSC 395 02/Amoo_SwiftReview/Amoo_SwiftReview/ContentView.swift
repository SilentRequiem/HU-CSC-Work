//
//  ContentView.swift
//  Amoo_SwiftReview
//
//  Created by Computer Science Swift on 9/5/26.
//

import SwiftUI
import SwiftData
import Observation

@Model
class ReviewResource {
    var title: String
    var topic: ReviewTopic?
    
    init(title: String, topic: ReviewTopic? = nil) {
        self.title = title
        self.topic = topic
    }
}

@Model
class ReviewTopic {
    var name: String
    var isReviewed: Bool
    var notes: String
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \ReviewResource.topic
    )
    var resources: [ReviewResource] = []
    
    init(name: String, isReviewed: Bool, notes: String = "") {
        self.name = name
        self.isReviewed = isReviewed
        self.notes = notes
    }
}

@Observable
class ReviewSession {
    var reviewGoal = 3
}

struct TopicRow: View {
    var topic: ReviewTopic

    var body: some View {
        HStack {
            NavigationLink {
                TopicDetailView(topic: topic)
            } label: {
                Text(topic.name)
            }

            Spacer()

            Button {
                topic.isReviewed.toggle()
            } label: {
                Image(
                    systemName: topic.isReviewed
                        ? "checkmark.circle.fill"
                        : "circle"
                )
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(
                topic.isReviewed
                    ? "Mark \(topic.name) as not reviewed"
                    : "Mark \(topic.name) as reviewed"
            )
        }
    }
}

struct TopicDetailView: View {
    @Bindable var topic: ReviewTopic

    @Environment(\.modelContext) private var context
    @State private var newResourceTitle = ""

    var body: some View {
        Form {

            Section("Topic") {
                TextField("Topic name", text: $topic.name)
            }

            Section("Status") {
                Toggle("Reviewed", isOn: $topic.isReviewed)
            }

            Section("Notes") {
                TextEditor(text: $topic.notes)
                    .frame(minHeight: 120)
            }

            Section("Resources") {
                TextField(
                    "Resource name",
                    text: $newResourceTitle
                )

                Button("Add Resource") {
                    if !newResourceTitle.isEmpty {
                        let resource = ReviewResource(
                            title: newResourceTitle,
                            topic: topic
                        )

                        context.insert(resource)

                        newResourceTitle = ""
                    }
                }

                ForEach(topic.resources) { resource in
                    Text(resource.title)
                }
            }
        }
        .navigationTitle(topic.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
    
    struct ContentView: View {
        
        @Query private var topics: [ReviewTopic]
        @Environment(\.modelContext) private var context
        @Environment(ReviewSession.self) private var reviewSession
        @State private var newTopic = ""
        
        var reviewedCount: Int {
            topics.filter{$0.isReviewed}.count
        }
        
        var achievement: String {
            if reviewedCount >= 5 {
                return "Swift Specialist"
            } else if reviewedCount >= 3 {
                return "Getting There"
            } else if reviewedCount >= 1 {
                return "First Review"
            } else {
                return "Getting Started"
            }
        }
        
        var body: some View {
            @Bindable var reviewSession = reviewSession
            NavigationStack {
                VStack {
                    Text("CSC Swift Review")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    
                    Text("Topics Reviewed: \(reviewedCount) / \(topics.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Achievement: \(achievement)")
                        .font(.subheadline)
                    
                    Stepper(
                        "Review Goal: \(reviewSession.reviewGoal)",
                        value: $reviewSession.reviewGoal,
                        in: 1...100
                    )
                    .padding()
                    
                    
                    TextField("Enter a topic", text: $newTopic)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Add Topic") {
                        if !newTopic.isEmpty {
                            
                            let topic = ReviewTopic(
                                name: newTopic,
                                isReviewed: false
                            )
                            context.insert(topic)
                            newTopic = ""
                        }
                    }
                    .padding()
                    
                    NavigationLink("Test Sentiment Analysis") {
                        SentimentView()
                    }
                    
                    NavigationLink("Test Vision OCR") {
                        VisionTestView()
                    }
                    
                    List {
                        ForEach(topics) { topic in
                            TopicRow(topic: topic)
                        }
                        .onDelete { offsets in
                            for index in offsets {
                                context.delete(topics[index])
                            }
                        }
                    }
                }
            }
        }
    }
    
#Preview {
    ContentView()
        .modelContainer(
            for: [ReviewTopic.self, ReviewResource.self],
            inMemory: true
        )
        .environment(ReviewSession())
}
