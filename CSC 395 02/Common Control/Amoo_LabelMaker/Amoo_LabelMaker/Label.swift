//
//  Label.swift
//  Amoo_LabelMaker
//
//  Created by Computer Science Swift on 10/21/26.
//


import Foundation
import SwiftUI


struct Label: Hashable, Codable {
    var id = UUID()
    var text = ""
    var cornerRadius = 20.0
    var colorIndex = 0


    static let colors: [Color] = [.cyan, .green, .indigo]


    func selectedColor() -> Color {
        Label.colors[colorIndex]
    }
}
