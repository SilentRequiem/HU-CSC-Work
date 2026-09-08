//
//  Order.swift
//  HUCart
//
//  Created by Michael Amoo on 5/4/25.
//

import Foundation

struct Order: Identifiable {
    let id = UUID()
    let store: Store
    let products: [Product]
    let date: Date
    let totalPrice: Double
}
