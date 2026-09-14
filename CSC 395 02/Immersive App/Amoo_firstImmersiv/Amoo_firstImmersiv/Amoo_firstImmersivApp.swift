//
//  Amoo_firstImmersivApp.swift
//  Amoo_firstImmersiv
//
//  Created by Computer Science Swift on 9/9/26.
//

import SwiftUI

@main
struct Amoo_firstImmersivApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
                    ImmersiveView()
                }
    }
}
