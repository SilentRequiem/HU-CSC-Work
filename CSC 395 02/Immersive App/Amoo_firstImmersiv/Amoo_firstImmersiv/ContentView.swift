//
//  ContentView.swift
//  Amoo_firstImmersiv
//
//  Created by Computer Science Swift on 9/9/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var enlarge = false

    @Environment(\.openImmersiveSpace)
    private var openImmersiveSpace

    var body: some View {
        VStack {
            RealityView { content in
                if let scene = try? await Entity(
                    named: "Scene",
                    in: realityKitContentBundle
                ) {
                    content.add(scene)
                }
            } update: { content in
                if let scene = content.entities.first {
                    let uniformScale: Float = enlarge ? 1.4 : 1.0

                    scene.transform.scale = [
                        uniformScale,
                        uniformScale,
                        uniformScale
                    ]
                }
            }
            .gesture(
                TapGesture()
                    .targetedToAnyEntity()
                    .onEnded { _ in
                        enlarge.toggle()
                    }
            )

            VStack(spacing: 16) {
                Toggle("Change Size", isOn: $enlarge)
                    .toggleStyle(.button)

                Button("Open Immersive Space") {
                    Task {
                        await openImmersiveSpace(
                            id: "ImmersiveSpace"
                        )
                    }
                }
            }
            .padding()
            .glassBackgroundEffect()
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
