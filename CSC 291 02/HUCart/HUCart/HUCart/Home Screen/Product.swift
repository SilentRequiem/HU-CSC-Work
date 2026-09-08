//
//  Product.swift
//  HUCart
//
//  Created by Michael Amoo on 5/4/25.
//

import Foundation

struct Product: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    let imageName: String
    let description: String
}
