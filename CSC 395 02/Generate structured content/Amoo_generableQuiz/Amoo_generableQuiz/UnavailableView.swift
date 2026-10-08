//
//  UnavailableView.swift
//  Amoo_generableQuiz
//
//  Created by Computer Science Swift on 10/2/26.
//


import SwiftUI
import FoundationModels


struct UnavailableView: View {
    let reason: SystemLanguageModel.Availability.UnavailableReason


    var body: some View {
        let text = switch reason {
        case .appleIntelligenceNotEnabled:
            "Apple Intelligence is not enabled. Please enable it in Settings."
        case .deviceNotEligible:
            "This device is not eligible for Apple Intelligence. Please use a compatible device."
        case .modelNotReady:
            "The language model is not ready."
        @unknown default:
            "The language model is unavailable."
        }
        ContentUnavailableView(text, systemImage: "apple.intelligence.badge.xmark")
    }
}


#Preview {
    UnavailableView(reason: .appleIntelligenceNotEnabled)
}
