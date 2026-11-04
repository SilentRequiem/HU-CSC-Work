//
//  Amoo_LabelMakerApp.swift
//  Amoo_LabelMaker
//
//  Created by Computer Science Swift on 10/21/26.
//

import SwiftUI


@main
struct LabelMakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)


        WindowGroup(for: Label.self) { $label in
            LabelView(label: $label)
                .disabled(true)
        } defaultValue: {
            Label(text: "", cornerRadius: 20)
        }
        .windowResizability(.contentSize)
        .windowStyle(.plain)
    }
}
