//
//  AppManager.swift
//  Amoo_imageGenApp
//
//  Created by Computer Science Swift on 9/28/26.
//


import SwiftUI
import ImagePlayground


@MainActor
@Observable
class AppManager {
    let imageGenerator = ImageGenerator()
    var showPlayground = false
    var currentImage: NSImage?


    private(set) var error: Error?
    private(set) var isGenerating = false
    private var task: Task<Void, Never>?


    func generateImage() {
        error = nil
        isGenerating = true
        task?.cancel()


        task = Task {
            do {
                let generatedImage = try await imageGenerator.generate()
                let cgImage = generatedImage.cgImage
                currentImage = NSImage(
                    cgImage: cgImage,
                    size: NSSize(width: cgImage.width, height: cgImage.height)
                )
                isGenerating = false
            } catch is CancellationError {
                // Superseded by a newer request — let that task own the state.
            } catch {
                // A cancelled creator can surface its own error type rather
                // than CancellationError, so check the flag as well.
                guard !Task.isCancelled else { return }
                self.error = error
                isGenerating = false
            }
        }
    }


    func reset() {
        task?.cancel()
        imageGenerator.resetGenerator()
        currentImage = nil
        error = nil
        isGenerating = false
    }


    func remove(ingredient: String) {
        guard let index = imageGenerator.ingredients.firstIndex(of: ingredient) else { return }
        imageGenerator.ingredients.remove(at: index)
        generateImage()
    }


    func add(ingredient: String) {
        let trimmed = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let isDuplicate = imageGenerator.ingredients.contains {
            $0.caseInsensitiveCompare(trimmed) == .orderedSame
        }
        guard !isDuplicate else { return }
        imageGenerator.ingredients.append(trimmed)
        generateImage()
    }


    var showKitchen: Bool {
        currentImage != nil || isGenerating
    }
}


extension View {
    func previewEnvironment(generateImage: Bool = true) -> some View {
        let appManager = AppManager()
        appManager.imageGenerator.ingredients.append("Strawberry")
        return environment(appManager)
            .onAppear {
                if generateImage {
                    appManager.imageGenerator.style = .animation
                    appManager.generateImage()
                }
            }
    }
}
