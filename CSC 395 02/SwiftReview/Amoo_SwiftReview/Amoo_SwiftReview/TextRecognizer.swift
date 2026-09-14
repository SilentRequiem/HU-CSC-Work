//
//  TextRecognizer.swift
//  Amoo_SwiftReview
//
//  Created by Computer Science Swift on 9/5/26.
//

import SwiftUI
import Vision

struct TextRecognizer {
    var recognizedText = ""

    init(imageResource: ImageResource) async {
        let request = RecognizeTextRequest()

        let image = UIImage(resource: imageResource)

        guard let imageData = image.pngData(),
              let observations = try? await request.perform(on: imageData)
        else {
            return
        }

        for observation in observations {
            let candidates = observation.topCandidates(1)

            if let text = candidates.first?.string {
                recognizedText += "\(text) "
            }
        }
    }
}
