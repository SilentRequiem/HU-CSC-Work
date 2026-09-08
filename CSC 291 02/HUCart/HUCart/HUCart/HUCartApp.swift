//
//  HUCartApp.swift
//  HUCart
//
//  Created by Michael Amoo on 4/9/25.

import SwiftUI

@main
struct HUCartApp: App {
    @StateObject private var cartManager = CartManager()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(cartManager)
                .preferredColorScheme(.light)
        }
    }
}


