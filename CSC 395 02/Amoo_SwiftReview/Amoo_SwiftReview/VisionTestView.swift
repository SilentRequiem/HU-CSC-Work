//
//  VisionTestView.swift
//  Amoo_SwiftReview
//
//  Created by Computer Science Swift on 9/6/26.
//

import SwiftUI
import Vision

struct VisionTestView: View {
    @State private var result = "No text recognized yet"

    var body: some View {
        VStack(spacing: 20) {
            Image("TestText")
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Button("Recognize Text") {
                recognizeText()
            }

            Text(result)
        }
        .padding()
        .navigationTitle("Vision OCR")
    }

    func recognizeText() {
        guard let image = UIImage(named: "TestText"),
              let cgImage = image.cgImage else {
            result = "Image not found."
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard let observations =
                    request.results as? [VNRecognizedTextObservation] else {
                return
            }

            let text = observations.compactMap {
                $0.topCandidates(1).first?.string
            }

            result = text.joined(separator: "\n")
        }

        request.recognitionLevel = .accurate

        let handler = VNImageRequestHandler(cgImage: cgImage)

        try? handler.perform([request])
    }
}
