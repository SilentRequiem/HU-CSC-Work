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

# Create ML Training Exercises

The `Train a Core ML Model` folder contains two Create ML exercises that use the same general machine-learning workflow with two different kinds of data.

```text
Data
  ↓
Choose the correct model type
  ↓
Train
  ↓
Validate / evaluate
  ↓
Test with new data
  ↓
Export a Core ML model
```

The important difference is the kind of problem being solved.

| Part | Data | Create ML task | Output |
| --- | --- | --- | --- |
| Part 1 | CSV / tabular trail data | Tabular Regression | A predicted numeric value |
| Part 2 | Fruit images | Image Classification | A predicted class such as Apple, Banana, or Orange |

---

## Part 1: TrailAnalyzer - Tabular Regression

The first exercise uses **structured CSV data**. Each row contains values describing a trail, and the model learns a relationship between those input values and the numeric value it is supposed to predict.

The Create ML project is:

```text
Train a Core ML Model
└── Part 1
    └── TrailAnalyzer.mlproj
```

### Model type

`TrailAnalyzer` uses **Tabular Regression**.

Regression is used when the value you want to predict is a **number on a continuous scale** rather than a category.

Examples of regression problems:

```text
Predict trail difficulty score
Predict house price
Predict temperature
Predict travel time
```

### Important terms

#### Feature

A **feature** is an input value the model can use to make a prediction.

For trail data, features can include values such as:

```text
Distance
Elevation
Other trail characteristics
```

Think:

```text
Features = clues given to the model
```

#### Target

The **target** is the value the model is trying to learn to predict.

```text
Features ──→ model ──→ target prediction
```

#### Tabular data

Tabular data is information arranged in rows and columns, similar to a spreadsheet.

```text
Row 1 = one trail
Row 2 = another trail
Row 3 = another trail
```

Each column represents a feature or the target.

### Training process

The general workflow for Part 1 was:

1. Open Create ML.
2. Create a **Tabular Regression** project.
3. Import the trail CSV data.
4. Choose the target column.
5. Choose the useful feature columns.
6. Train the model.
7. Examine the training and validation results.
8. Test the model with data it did not directly train on.
9. Export/save the trained Core ML model.

### What the model learns

The model is not memorizing Swift code or hardcoded `if` statements.

Instead, it tries to learn a mathematical relationship between the input features and the target.

```text
Trail characteristics
        ↓
 learned relationship
        ↓
 predicted numeric result
```

### Training, validation, and testing

#### Training data

Used to teach the model.

#### Validation data

Used during training to see how well the model is learning on data that is not being used directly to fit each training step.

#### Testing data

Used after training to check how the finished model performs on unseen examples.

A useful rule:

> A model is more useful when it performs well on new data, not only on the examples it trained on.

### Regression tips

- Make sure the target column is the value you actually want to predict.
- Do not accidentally include a column that directly gives away the answer.
- Input columns should contain useful information related to the target.
- A model that performs extremely well on training data but poorly on new data may be **overfitting**.
- Always test predictions with values the model did not simply memorize.

---

## Part 2: Amoo_FruitAnalyzer - Image Classification

The second exercise uses **images instead of CSV rows**.

The Create ML project is:

```text
Train a Core ML Model
└── Part 2
    └── Amoo_FruitAnalyzer.mlproj
```

The exported trained model is also stored in the Part 2 folder.

### Model type

`Amoo_FruitAnalyzer` uses **Image Classification**.

Classification is used when the model must choose between categories.

For this project, the categories are:

```text
Apple
Banana
Orange
```

Instead of predicting a number, the model answers a question like:

```text
What class does this image belong to?
```

### How image training data is labeled

For Create ML image classification, folder structure is used to provide the labels.

Example:

```text
Training
├── Apple
│   ├── image1.jpg
│   ├── image2.jpg
│   └── ...
├── Banana
│   ├── image1.jpg
│   ├── image2.jpg
│   └── ...
└── Orange
    ├── image1.jpg
    ├── image2.jpg
    └── ...
```

The folder names become the class labels.

That means the model learns:

```text
images inside Apple folder  → Apple examples
images inside Banana folder → Banana examples
images inside Orange folder → Orange examples
```

**Tip:** Drag the folder that directly contains the class folders into Create ML. If the wrong folder level is used, Create ML may interpret the dataset incorrectly.

### Training process

The general workflow for Part 2 was:

1. Extract the provided fruit training data.
2. Open Create ML.
3. Create an **Image Classification** project.
4. Load the training folder containing the Apple, Banana, and Orange folders.
5. Confirm that Create ML recognizes the correct classes.
6. Train the model.
7. Review training and validation performance.
8. Use Preview or testing data to classify images.
9. Test with fruit images that were not part of the original training examples.
10. Export the trained `.mlmodel`.

### What the image classifier learns

Unlike the trail model, there are no manually selected numeric feature columns such as distance or elevation.

The image classifier learns useful visual patterns from the images.

Conceptually:

```text
Image pixels
    ↓
visual features and patterns
    ↓
trained classifier
    ↓
Apple / Banana / Orange
```

The model may learn patterns related to:

```text
Shape
Color
Texture
Edges
Object appearance
```

The exact learned representation is determined during training rather than manually written as Swift conditions.

### Prediction and confidence

An image classifier normally produces a predicted class and confidence information.

Conceptually:

```text
New image
   ↓
Amoo_FruitAnalyzer
   ↓
Banana
Confidence: high
```

A confidence score tells you how strongly the model favors a prediction. It does not mean the model is guaranteed to be correct.

### Testing with unseen images

One of the most important tests is to use an image that was **not used for training**.

```text
Training image → useful for teaching
New image      → useful for checking generalization
```

If the model only works on its training photos, it has not learned a useful general pattern.

### Image classification tips

- Use several examples for every class.
- Try to keep the number of training images reasonably balanced between classes.
- Include variety in angle, lighting, background, size, and position when possible.
- Avoid using nearly identical copies of the same photo as most of the dataset.
- Use new images during Preview/testing.
- If the classifier depends too heavily on the background instead of the fruit, add more varied training examples.
- A high training accuracy does not automatically mean the model will work perfectly in the real world.

---

## Regression vs Classification

This is the biggest conceptual difference between the two exercises.

### Regression

```text
Input → model → NUMBER
```

Example:

```text
Trail characteristics → predicted difficulty value
```

### Classification

```text
Input → model → CATEGORY
```

Example:

```text
Fruit image → Apple / Banana / Orange
```

A quick way to decide:

```text
"How much / how many / what numeric value?"
        ↓
    Regression

"Which type / which class / which category?"
        ↓
  Classification
```

---

## Create ML Vocabulary

| Term | Meaning |
| --- | --- |
| Machine learning model | A system that learns patterns from examples so it can make predictions on new input. |
| Training data | Examples used to teach the model. |
| Validation data | Data used during the training process to check how well the model generalizes. |
| Testing data | Unseen examples used to evaluate the finished model. |
| Feature | An input used to make a prediction. |
| Target | The value a supervised model is trying to predict. |
| Label | The correct class/category attached to a training example. |
| Regression | Predicts a numeric value. |
| Classification | Predicts a category/class. |
| Image classifier | A classification model whose input is an image. |
| Confidence | How strongly the classifier favors a prediction. |
| Overfitting | When a model learns the training examples too specifically and performs worse on new data. |
| Generalization | The ability to perform well on new data that was not used for training. |
| Core ML model | Apple's deployable machine-learning model format for use in Apple-platform apps. |
| Create ML project (`.mlproj`) | The Create ML training project containing data-source and model-training configuration. |
| `.mlmodel` | An exported trained Core ML model that can be added to an Apple app. |

---

## Shared Lessons From Both Create ML Exercises

### 1. Match the model type to the question

Before training anything, ask:

```text
What am I trying to predict?
```

If the answer is a number, regression may be appropriate.

If the answer is a category, classification may be appropriate.

### 2. Data quality matters

A machine-learning model learns from the examples it receives.

Bad or misleading data can teach bad patterns.

```text
Good examples → better chance of useful predictions
Poor examples → unreliable predictions
```

### 3. Training performance is not the whole story

The goal is not just to get a model that performs well on its training set.

The real question is:

> Does it work on new examples?

### 4. Keep training and testing conceptually separate

Do not judge a model only by feeding it the same examples it already saw during training.

### 5. Save both the project and the exported model

```text
.mlproj
→ useful for reopening and retraining the Create ML project

.mlmodel
→ trained model that can be used by an app
```

### 6. Screenshots should show evidence of the workflow

Useful screenshots for class submissions include:

```text
Training setup
Training results
Validation/evaluation results
Preview/test predictions
Export/output screen
```

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
9. **For ML, identify the prediction type first.** Number = think regression. Category = think classification.
10. **Always test ML models on new examples.** Training accuracy alone is not enough.

---

## Project Files

| File / Folder | Purpose |
| --- | --- |
| `Amoo_SwiftReviewApp.swift` | App entry point, SwiftData container, and shared `ReviewSession` environment. |
| `ContentView.swift` | Review models, topic list, navigation, CRUD behavior, progress, and topic details. |
| `DocumentationView.swift` | In-app reference for concepts, definitions, examples, and tips from this mini-lab. |
| `SentimentView.swift` | Natural Language sentiment-analysis example. |
| `TextRecognizer.swift` | Vision text-recognition helper. |
| `VisionTestView.swift` | SwiftUI interface for testing OCR on an image. |
| `Train a Core ML Model/Part 1/TrailAnalyzer.mlproj` | Create ML Tabular Regression project. |
| `Train a Core ML Model/Part 2/Amoo_FruitAnalyzer.mlproj` | Create ML Image Classification project. |
| `Train a Core ML Model/Part 2/Amoo_FruitAnalyzer 1.mlmodel` | Exported fruit image-classification Core ML model. |

---

## Main Takeaway

The biggest SwiftUI idea from the mini-lab is that **SwiftUI is driven by data**.

```text
Data changes
    ↓
SwiftUI observes the change
    ↓
body is reevaluated
    ↓
The interface reflects the current data
```

The biggest machine-learning idea from the Create ML exercises is that **the type of prediction determines the type of model**.

```text
Predict a number
    ↓
Regression

Predict a category
    ↓
Classification
```

Once the ownership and flow of app data are clear, and once the ML problem type is clear, the rest of the implementation becomes much easier to reason about.
