//
//  ImageGenerator.swift
//  Amoo_imageGenApp
//
//  Created by Computer Science Swift on 9/28/26.
//


import SwiftUI
import ImagePlayground


@MainActor
@Observable
class ImageGenerator {
    var recipe = ImageGenerator.defaultRecipe
    var style: ImagePlaygroundStyle?
    var ingredients: [String] = []


    var concepts: [ImagePlaygroundConcept] {
        var playgroundConcepts = [ImagePlaygroundConcept.text(recipe)]
        for ingredient in ingredients {
            playgroundConcepts.append(.text(ingredient))
        }
        return playgroundConcepts
    }


    func generate() async throws -> ImageCreator.CreatedImage {
        guard let style else { throw ImageCreator.Error.creationFailed }


        let imageCreator = try await ImageCreator()
        let images = imageCreator.images(for: concepts, style: style, limit: 1)
        for try await image in images {
            return image
        }


        throw ImageCreator.Error.creationFailed
    }


    func resetGenerator() {
        recipe = ImageGenerator.defaultRecipe
        style = nil
        ingredients.removeAll()
    }
}


extension ImageGenerator {
    static let recipes = ["Salad", "Sandwich", "Ice Cream"]
    static let styles: [ImagePlaygroundStyle] = [
        .animation,
        .illustration,
        .sketch
    ]


    static let imageSize: CGFloat = 256
    private static let defaultRecipe = recipes[0]
}
