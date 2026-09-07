# CSC 395-02 | Advanced Swift / ARKit

This folder contains work for **CSC 395-02: Advanced Swift App Development with ARKit**.

The `Amoo_SwiftReview` project is a mini-lab built to review the SwiftUI and data-modeling concepts from the assigned Apple tutorials. It also includes small Natural Language and Vision examples.

## SwiftUI Review Mini-Lab

### What the app does

The app lets you:

- Add Swift review topics.
- Mark topics as reviewed or not reviewed.
- Track the number of completed topics.
- Set a review goal.
- Open a topic detail screen.
- Edit a topic name.
- Add notes to a topic.
- Add related resources to a topic.
- Delete topics.
- Save topics with SwiftData so they survive app restarts.
- Run a small Natural Language sentiment test.
- Run a Vision OCR text-recognition test.
- Open an in-app documentation screen with definitions and tips from the mini-lab.

---

## Core Concepts

### Swift Fundamentals

| Concept | Definition | Tip |
| --- | --- | --- |
| `struct` | A custom value type that groups related properties and behavior. SwiftUI views are commonly structs. | Think of it as a blueprint for a value. |
| `class` | A reference type. SwiftData models in this project are classes. | Use the type expected by the framework you are working with. |
| `var` | Creates a value that can change. | Use it when the value will be edited. |
| `let` | Creates a constant value. | Prefer it when the value should stay fixed. |
| `String` | Stores text. | Example: a topic name or notes. |
| `Bool` | Stores `true` or `false`. | Good for yes/no state such as `isReviewed`. |
| Array | Stores multiple values of the same type in order. | `[ReviewResource]` is an array of resources. |
| Closure | A block of code that can run later. | Button actions and many SwiftUI builders use closures. |
| Computed property | Calculates its value when requested instead of storing a separate result. | Use one when a value can be derived from other data. |
| String interpolation | Inserts values into a String with `\(value)`. | Useful for counters and labels. |

### Example

```swift
var reviewedCount: Int {
    topics.filter { $0.isReviewed }.count
}
```

`reviewedCount` is computed from the current topics. It does not need its own stored value.

---

## SwiftUI Views and Layout

### `View` and `body`

A SwiftUI view describes part of the interface.

```swift
struct TopicRow: View {
    var body: some View {
        Text("SwiftUI")
    }
}
```

`body` describes what SwiftUI should display for the current data.

### Layout

- `VStack` arranges views vertically.
- `HStack` arranges views horizontally.
- `Spacer()` fills available space between views.

```swift
HStack {
    Text(topic.name)
    Spacer()
    Image(systemName: "circle")
}
```

### Common controls used

- `Text` displays text.
- `TextField` accepts shorter text input.
- `TextEditor` accepts multi-line text.
- `Button` runs an action.
- `Toggle` edits a Boolean.
- `Stepper` increases or decreases a numeric value.
- `List` displays scrolling rows.
- `ForEach` creates a view for every item in a collection.
- `Form` creates an iOS-style data-entry layout.
- `Section` groups related controls.

### Modifiers

Modifiers change the appearance or behavior of a view.

```swift
Text("CSC Swift Review")
    .font(.title)
    .fontWeight(.bold)
```

**Tip:** Read a modifier chain from top to bottom as changes being applied to the original view.

---

## State and Data Flow

This was one of the most important parts of the mini-lab.

### `@State`

`@State` stores temporary data owned by a SwiftUI view.

```swift
@State private var newTopic = ""
```

When a state value changes, SwiftUI can update the affected interface.

**Use it for:** temporary UI data such as unfinished text input.

### Binding and `$`

The `$` symbol gives a control a two-way connection to a value.

```swift
TextField("Enter a topic", text: $newTopic)
```

A useful way to remember it:

```text
newTopic   = read the current value
$newTopic  = get a binding that can read and change it
```

### `@Binding`

A child view can use `@Binding` to edit state owned elsewhere instead of creating a copy.

### `@Bindable`

`@Bindable` lets SwiftUI controls create bindings to properties of an observable object.

```swift
@Bindable var topic: ReviewTopic

TextField("Topic name", text: $topic.name)
```

### `@Observable`

`@Observable` makes an object's changing properties observable.

```swift
@Observable
class ReviewSession {
    var reviewGoal = 3
}
```

This project uses `ReviewSession` as shared live app state.

### `@Environment`

`@Environment` reads shared values supplied higher in the SwiftUI hierarchy.

```swift
@Environment(ReviewSession.self) private var reviewSession
```

The main app provides the object with:

```swift
.environment(reviewSession)
```

**Tip:** A preview must provide required environment values too.

---

## Navigation

### `NavigationStack`

Provides the navigation hierarchy.

### `NavigationLink`

Displays something tappable and opens another view.

```swift
NavigationLink {
    TopicDetailView(topic: topic)
} label: {
    Text(topic.name)
}
```

**Important lesson:** Creating a `View` type does not automatically display it. The view must be placed in `body` or reached through navigation.

---

## SwiftData and Persistence

### Persistence

Persistence means the data survives after the app stops running.

The mini-lab originally used an in-memory array. It was later converted to SwiftData so topics remain after stopping and reopening the app.

### `@Model`

Marks a class as a SwiftData model.

```swift
@Model
class ReviewTopic {
    var name: String
    var isReviewed: Bool
    var notes: String
}
```

### `modelContainer`

The model container configures SwiftData storage for the app.

```swift
.modelContainer(
    for: [ReviewTopic.self, ReviewResource.self]
)
```

A useful distinction:

```text
modelContainer = provides/configures SwiftData storage
modelContext   = lets a view work with that storage
```

### `@Query`

Reads SwiftData models and keeps the view updated when the stored data changes.

```swift
@Query private var topics: [ReviewTopic]
```

### `ModelContext`

The model context is used to insert and delete models.

```swift
context.insert(topic)
context.delete(topics[index])
```

### CRUD

CRUD is a common way to describe basic data operations:

| Letter | Operation | Mini-lab example |
| --- | --- | --- |
| C | Create | `context.insert(topic)` |
| R | Read | `@Query` |
| U | Update | Editing model properties such as `topic.name` |
| D | Delete | `context.delete(...)` |

---

## SwiftData Relationships

A `ReviewTopic` can have multiple `ReviewResource` objects.

```text
ReviewTopic
├── ReviewResource
├── ReviewResource
└── ReviewResource
```

This is a one-to-many relationship.

```swift
@Relationship(
    deleteRule: .cascade,
    inverse: \ReviewResource.topic
)
var resources: [ReviewResource] = []
```

### `inverse`

The inverse tells SwiftData about the other side of the relationship.

```text
ReviewTopic.resources  <->  ReviewResource.topic
```

### `.cascade`

A cascade delete rule means that deleting the parent topic also deletes its dependent resources.

**Tip:** Use cascade only when the child data no longer makes sense without the parent.

---

## Identity and Objects

Earlier in the review, topics used `Identifiable` and `UUID()` so SwiftUI could distinguish rows.

A useful distinction:

```text
topic       = the whole ReviewTopic object
topic.name  = one property inside the object
```

Also remember:

```swift
ReviewTopic(
    name: newTopic,
    isReviewed: false
)
```

creates a new object.

It does **not** store it by itself.

The separate storage step is:

```swift
context.insert(topic)
```

---

## App Logic and Refinement

### Derived UI

The UI can be calculated from existing data.

```swift
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
```

The achievement does not need to be manually updated. It is derived from `reviewedCount`.

### Accessibility

Icon-only controls should have meaningful accessibility descriptions.

```swift
.accessibilityLabel(
    topic.isReviewed
        ? "Mark \(topic.name) as not reviewed"
        : "Mark \(topic.name) as reviewed"
)
```

**Tip:** Do not rely only on an icon or color to communicate important meaning.

---

## Natural Language

The project includes a small sentiment-analysis view using Apple's Natural Language framework.

```swift
import NaturalLanguage

let tagger = NLTagger(tagSchemes: [.sentimentScore])
tagger.string = inputText
```

The app asks `NLTagger` for a sentiment score for the entered reflection.

### Flow

```text
Text
  ↓
NLTagger
  ↓
sentimentScore
  ↓
Result shown in SwiftUI
```

**Tip:** Test one clearly positive and one clearly negative sentence first so the difference is easy to see.

---

## Vision and OCR

OCR stands for **Optical Character Recognition**.

The project uses Vision to read text from an image.

```swift
let request = VNRecognizeTextRequest { request, error in
    // process recognized text
}
```

The request returns recognized text observations. The app chooses the strongest candidate from each observation.

### Flow

```text
Image
  ↓
Vision request
  ↓
Recognized text observations
  ↓
topCandidates(1)
  ↓
String
```

**Tip:** Clear, high-contrast images with readable text usually work better for OCR.

---

## Common Mistakes and Fixes From the Mini-Lab

### `modelContext` vs `modelContainer`

The preview originally used the wrong modifier.

Incorrect:

```swift
.modelContext(for: ReviewTopic.self)
```

Correct:

```swift
.modelContainer(for: ReviewTopic.self)
```

The container provides storage. The context is accessed from the environment to work with the storage.

### Missing preview environment

If `ContentView` expects:

```swift
@Environment(ReviewSession.self) private var reviewSession
```

the preview also needs:

```swift
.environment(ReviewSession())
```

### A view exists but cannot be opened

`SentimentView` and the documentation view only appear if the app actually links to them.

```swift
NavigationLink("Test Sentiment Analysis") {
    SentimentView()
}
```

### `topic` vs `topic.name`

`topic` is the whole model object. `topic.name` is only its name property.

### `ReviewTopic(...)` vs inserting

Creating the model and storing the model are separate operations.

```swift
let topic = ReviewTopic(name: newTopic, isReviewed: false)
context.insert(topic)
```

---

## Quick Study Tips

1. **Follow the data.** When confused by SwiftUI, identify where the data is owned, who can edit it, and which views read it.
2. **Value vs binding:** `value` reads. `$value` creates a two-way connection.
3. **Temporary vs persistent:** `@State` is temporary UI state. SwiftData models are persistent app records.
4. **Keep one source of truth.** Calculate values like progress or achievements instead of storing duplicate state.
5. **Break framework code into stages:** input → processing → result → UI.
6. **Use Xcode errors literally.** A type mismatch often tells you exactly what kind of value the API expected.
7. **Test the smallest working version first.** Add one feature, run it, and then move to the next feature.
8. **Previews need dependencies too.** If the real app supplies a model container or environment object, the preview often needs one as well.

---

## Project Files

| File | Purpose |
| --- | --- |
| `Amoo_SwiftReviewApp.swift` | App entry point, SwiftData container, and shared `ReviewSession` environment. |
| `ContentView.swift` | Review models, topic list, navigation, CRUD behavior, progress, and topic details. |
| `DocumentationView.swift` | In-app reference for concepts, definitions, examples, and tips from this mini-lab. |
| `SentimentView.swift` | Natural Language sentiment-analysis example. |
| `TextRecognizer.swift` | Vision text-recognition helper. |
| `VisionTestView.swift` | SwiftUI interface for testing OCR on an image. |

---

## Main Takeaway

The biggest idea from this mini-lab is that **SwiftUI is driven by data**.

```text
Data changes
    ↓
SwiftUI observes the change
    ↓
body is reevaluated
    ↓
The interface reflects the current data
```

Once the ownership and flow of the data are clear, features such as lists, editing, navigation, persistence, shared state, and even AI-powered views become easier to reason about.
