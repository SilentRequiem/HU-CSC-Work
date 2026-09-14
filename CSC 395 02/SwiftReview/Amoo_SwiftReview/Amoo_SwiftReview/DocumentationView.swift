//
//  DocumentationView.swift
//  Amoo_SwiftReview
//
//  Mini-lab review notes for CSC 395
//

import SwiftUI

struct DocumentationView: View {
    var body: some View {
        List {
            Section("Mini-Lab Purpose") {
                Text("This mini-lab reviews the SwiftUI, data modeling, persistence, navigation, observation, accessibility, Natural Language, and Vision concepts used in CSC 395.")
            }

            Section("Swift Fundamentals") {
                ConceptRow(
                    title: "struct",
                    definition: "A custom value type that groups related properties and behavior together. SwiftUI views are commonly structs.",
                    example: "struct TopicRow: View { ... }",
                    tip: "Think of a struct as a blueprint for creating values with the same shape."
                )

                ConceptRow(
                    title: "class",
                    definition: "A reference type. In this mini-lab, SwiftData models use classes so SwiftData can manage and observe model objects.",
                    example: "@Model class ReviewTopic { ... }",
                    tip: "Use the framework's expected type. SwiftData @Model objects are classes in this project."
                )

                ConceptRow(
                    title: "var and let",
                    definition: "var creates a value that can change. let creates a constant that should not change after it is created.",
                    example: "var name = \"SwiftUI\"\nlet id = UUID()",
                    tip: "Use let by default when a value should stay fixed."
                )

                ConceptRow(
                    title: "String and Bool",
                    definition: "String stores text. Bool stores one of two values: true or false.",
                    example: "var name: String\nvar isReviewed: Bool",
                    tip: "Bool is useful for yes/no state such as reviewed or not reviewed."
                )

                ConceptRow(
                    title: "Arrays",
                    definition: "An array stores multiple values of the same type in order.",
                    example: "var resources: [ReviewResource] = []",
                    tip: "[Type] describes the element type. [] creates an empty array."
                )

                ConceptRow(
                    title: "Closures",
                    definition: "A closure is a block of code that can run later. SwiftUI uses closures heavily for button actions and view builders.",
                    example: "Button(\"Add Topic\") {\n    // action\n}",
                    tip: "When you see { ... }, ask what event or operation causes that block to run."
                )

                ConceptRow(
                    title: "Computed Properties",
                    definition: "A computed property calculates a value when it is requested instead of permanently storing the result.",
                    example: "var reviewedCount: Int {\n    topics.filter { $0.isReviewed }.count\n}",
                    tip: "Use computed properties when a value can be derived from other data."
                )

                ConceptRow(
                    title: "String Interpolation",
                    definition: "String interpolation inserts a value into a String using \\(value).",
                    example: "Text(\"Topics Reviewed: \\(reviewedCount)\")",
                    tip: "Use interpolation instead of manually joining text and numbers."
                )
            }

            Section("SwiftUI Views and Layout") {
                ConceptRow(
                    title: "View and body",
                    definition: "A SwiftUI View describes part of the interface. body returns the view hierarchy SwiftUI should display.",
                    example: "struct ContentView: View {\n    var body: some View { ... }\n}",
                    tip: "SwiftUI is declarative: describe the UI for the current data instead of manually redrawing it."
                )

                ConceptRow(
                    title: "VStack, HStack, Spacer",
                    definition: "VStack arranges views vertically. HStack arranges them horizontally. Spacer fills available space between views.",
                    example: "HStack {\n    Text(topic.name)\n    Spacer()\n    Image(systemName: \"circle\")\n}",
                    tip: "Choose the stack based on the direction you want elements arranged."
                )

                ConceptRow(
                    title: "TextField and TextEditor",
                    definition: "TextField is useful for shorter text input. TextEditor supports larger multi-line text.",
                    example: "TextField(\"Topic name\", text: $topic.name)\nTextEditor(text: $topic.notes)",
                    tip: "Both need a Binding because the control must be able to change the value."
                )

                ConceptRow(
                    title: "Button, Toggle, Stepper",
                    definition: "Button runs an action. Toggle edits a Boolean. Stepper increases or decreases a numeric value.",
                    example: "Toggle(\"Reviewed\", isOn: $topic.isReviewed)",
                    tip: "Pick controls that match the data type being edited."
                )

                ConceptRow(
                    title: "List and ForEach",
                    definition: "List displays scrolling rows. ForEach creates a view for each item in a collection.",
                    example: "ForEach(topics) { topic in\n    TopicRow(topic: topic)\n}",
                    tip: "Items need stable identity so SwiftUI can track which row is which."
                )

                ConceptRow(
                    title: "Form and Section",
                    definition: "Form creates an iOS-style data entry or settings layout. Section groups related controls inside a Form or List.",
                    example: "Section(\"Notes\") {\n    TextEditor(text: $topic.notes)\n}",
                    tip: "Use sections to make larger forms easier to scan."
                )

                ConceptRow(
                    title: "Modifiers",
                    definition: "Modifiers change the appearance or behavior of a View and can be chained together.",
                    example: "Text(\"CSC Swift Review\")\n    .font(.title)\n    .fontWeight(.bold)",
                    tip: "Read modifier chains from top to bottom as changes applied to the view."
                )
            }

            Section("State and Data Flow") {
                ConceptRow(
                    title: "@State",
                    definition: "@State stores temporary data owned by a SwiftUI view. SwiftUI watches it and updates affected UI when it changes.",
                    example: "@State private var newTopic = \"\"",
                    tip: "Use @State for local UI data such as unfinished text input."
                )

                ConceptRow(
                    title: "Binding and the $ symbol",
                    definition: "A Binding is a two-way connection to a value. The $ symbol requests a Binding instead of only reading the current value.",
                    example: "TextField(\"Enter a topic\", text: $newTopic)",
                    tip: "value means read it. $value means give another control permission to read and change it."
                )

                ConceptRow(
                    title: "@Binding",
                    definition: "@Binding lets a child view edit state owned somewhere else without owning a separate copy.",
                    example: "@Binding var topic: ReviewTopic",
                    tip: "Use @Binding when the source of truth belongs to another view."
                )

                ConceptRow(
                    title: "@Bindable",
                    definition: "@Bindable creates bindings to editable properties of an observable object, including SwiftData model objects.",
                    example: "@Bindable var topic: ReviewTopic\nTextField(\"Topic\", text: $topic.name)",
                    tip: "It is useful when a model object already exists but controls need $ bindings to its properties."
                )

                ConceptRow(
                    title: "@Observable",
                    definition: "@Observable makes an object's changing properties observable so SwiftUI views can react to them.",
                    example: "@Observable\nclass ReviewSession {\n    var reviewGoal = 3\n}",
                    tip: "Use it for shared live app state that does not necessarily need database persistence."
                )

                ConceptRow(
                    title: "@Environment",
                    definition: "@Environment reads a shared dependency or value supplied higher in the SwiftUI view hierarchy.",
                    example: "@Environment(ReviewSession.self) private var reviewSession",
                    tip: "If a preview crashes because an environment value is missing, provide the same dependency in #Preview."
                )
            }

            Section("Navigation") {
                ConceptRow(
                    title: "NavigationStack",
                    definition: "NavigationStack provides a navigation hierarchy that can push detail views onto the screen.",
                    example: "NavigationStack {\n    ContentView()\n}",
                    tip: "NavigationLink needs a navigation container such as NavigationStack to push destinations."
                )

                ConceptRow(
                    title: "NavigationLink",
                    definition: "NavigationLink displays a tappable label and opens a destination View when selected.",
                    example: "NavigationLink {\n    TopicDetailView(topic: topic)\n} label: {\n    Text(topic.name)\n}",
                    tip: "Creating a View type does not make it visible. Something must actually present or navigate to it."
                )
            }

            Section("SwiftData and Persistence") {
                ConceptRow(
                    title: "Persistence",
                    definition: "Persistence means data survives after the app stops running and can be loaded again later.",
                    example: "Review topics remain after stopping and reopening the app.",
                    tip: "@State is temporary. SwiftData is used here for information that should survive app restarts."
                )

                ConceptRow(
                    title: "@Model",
                    definition: "@Model marks a class as a SwiftData model that can be managed and persisted.",
                    example: "@Model\nclass ReviewTopic { ... }",
                    tip: "Model properties become the data SwiftData stores and observes."
                )

                ConceptRow(
                    title: "modelContainer",
                    definition: "The model container configures the SwiftData storage used by the app and makes a model context available to child views.",
                    example: ".modelContainer(for: [ReviewTopic.self, ReviewResource.self])",
                    tip: "modelContainer provides storage. modelContext is what a view uses to interact with that storage."
                )

                ConceptRow(
                    title: "@Query",
                    definition: "@Query reads SwiftData model objects and automatically refreshes the view when matching stored data changes.",
                    example: "@Query private var topics: [ReviewTopic]",
                    tip: "Think of @Query as the read side of the app's SwiftData flow."
                )

                ConceptRow(
                    title: "ModelContext",
                    definition: "ModelContext is the working connection used to insert and delete SwiftData model objects.",
                    example: "context.insert(topic)\ncontext.delete(topics[index])",
                    tip: "Create the object first, then insert it into the context."
                )

                ConceptRow(
                    title: "CRUD",
                    definition: "CRUD stands for Create, Read, Update, Delete. These are the four basic data operations.",
                    example: "Create: context.insert\nRead: @Query\nUpdate: edit model properties\nDelete: context.delete",
                    tip: "If you can identify all four operations in an app, you understand the basic data lifecycle."
                )

                ConceptRow(
                    title: "@Relationship",
                    definition: "@Relationship describes how SwiftData model objects are connected. One ReviewTopic can contain many ReviewResource objects.",
                    example: "var resources: [ReviewResource] = []",
                    tip: "Relationships let related data stay connected instead of storing everything inside one large model."
                )

                ConceptRow(
                    title: "inverse and cascade",
                    definition: "inverse tells SwiftData about the other side of a relationship. A cascade delete rule deletes dependent related objects when the parent is deleted.",
                    example: "deleteRule: .cascade\ninverse: \\ReviewResource.topic",
                    tip: "Choose delete rules based on whether related records still make sense without their parent."
                )
            }

            Section("App Logic and Accessibility") {
                ConceptRow(
                    title: "Derived UI",
                    definition: "The interface can be calculated from current data instead of storing duplicate values. The reviewed count and achievement are derived from topic state.",
                    example: "topics.filter { $0.isReviewed }.count",
                    tip: "Avoid storing a second value when you can reliably calculate it from existing data."
                )

                ConceptRow(
                    title: "Accessibility labels",
                    definition: "An accessibility label gives assistive technologies a useful description of controls that may otherwise only show an icon.",
                    example: ".accessibilityLabel(\"Mark topic as reviewed\")",
                    tip: "Do not rely only on an icon or color to explain an important action."
                )
            }

            Section("Machine Learning and AI") {
                ConceptRow(
                    title: "Natural Language",
                    definition: "Apple's NaturalLanguage framework can analyze text. This mini-lab uses NLTagger with sentimentScore to estimate whether a reflection is more positive or negative.",
                    example: "NLTagger(tagSchemes: [.sentimentScore])",
                    tip: "The framework analyzes the text, but the app still decides how to display or use the result."
                )

                ConceptRow(
                    title: "Sentiment Analysis",
                    definition: "Sentiment analysis estimates the emotional tone of text and returns a score that can be interpreted by the app.",
                    example: "tagger.tag(... scheme: .sentimentScore)",
                    tip: "Test clearly positive and clearly negative sentences first so you can see the difference."
                )

                ConceptRow(
                    title: "Vision OCR",
                    definition: "OCR means Optical Character Recognition. Vision can inspect pixels in an image and return recognized text.",
                    example: "VNRecognizeTextRequest",
                    tip: "Clear, high-contrast text gives OCR a better chance of accurate recognition."
                )

                ConceptRow(
                    title: "Text Recognition Flow",
                    definition: "The app loads an image, creates a Vision text request, performs the request, receives text observations, chooses the best candidate, and converts it into Strings.",
                    example: "Image → request → observations → topCandidates(1) → String",
                    tip: "Break framework code into an input, processing step, result objects, and final UI output."
                )
            }

            Section("Tips I Want to Remember") {
                TipRow(text: "@State owns temporary view data. SwiftData stores persistent model data.")
                TipRow(text: "Use $ when a SwiftUI control needs a two-way connection to a value.")
                TipRow(text: "topic is the whole object. topic.name accesses one property inside it.")
                TipRow(text: "ReviewTopic(...) creates an object. insert() or append() is the separate step that stores it somewhere.")
                TipRow(text: "Identifiable means each item has a stable unique identity, not that it returns every property.")
                TipRow(text: "A View can exist in code without appearing in the app. Add it to body or navigate to it.")
                TipRow(text: "modelContainer provides SwiftData storage. modelContext interacts with that storage.")
                TipRow(text: "Previews need the same environment dependencies as the real app, such as model containers and ReviewSession.")
                TipRow(text: "Let the data drive the UI. Change the data and allow SwiftUI to update the screen.")
            }
        }
        .navigationTitle("What I Learned")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ConceptRow: View {
    let title: String
    let definition: String
    let example: String
    let tip: String

    var body: some View {
        DisclosureGroup(title) {
            VStack(alignment: .leading, spacing: 10) {
                Text(definition)

                Text(example)
                    .font(.system(.caption, design: .monospaced))
                    .textSelection(.enabled)

                Label(tip, systemImage: "lightbulb")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 6)
        }
    }
}

struct TipRow: View {
    let text: String

    var body: some View {
        Label(text, systemImage: "checkmark.circle")
            .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        DocumentationView()
    }
}
