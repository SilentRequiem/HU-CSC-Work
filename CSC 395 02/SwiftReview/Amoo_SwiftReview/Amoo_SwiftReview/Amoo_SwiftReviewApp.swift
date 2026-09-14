//
//  Amoo_SwiftReviewApp.swift
//  Amoo_SwiftReview
//
//  Created by Computer Science Swift on 9/5/26.
//

import SwiftUI
import SwiftData

@main
struct Amoo_SwiftReviewApp: App {
    @State private var reviewSession = ReviewSession()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(
                    for: [ReviewTopic.self, ReviewResource.self]
                    )
                .environment(reviewSession)
        }
    }
}
