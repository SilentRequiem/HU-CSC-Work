//
//  PredictionView.swift
//  Amoo_TrailAnalyzer
//
//  Created by Computer Science Swift on 9/7/26.
//


import SwiftUI


struct PredictionView: View {
    @State var predictedRisk: Risk


    var body: some View {
        VStack {
            RiskCard(risk: predictedRisk)
            Spacer()
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    riskSummaryView
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .trailTheme()
    }


    var riskSummaryView: some View {
        ScrollView {
            ForEach(Risk.allCases) {
                RiskCard(risk: $0)
            }
        }
        .trailTheme()
    }
}


#Preview {
    NavigationStack {
        PredictionView(predictedRisk: .moderate)
    }
}