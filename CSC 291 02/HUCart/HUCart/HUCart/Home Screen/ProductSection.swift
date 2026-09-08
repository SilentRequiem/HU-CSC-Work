//
//  ProductSection.swift
//  HUCart
//
//  Created by Michael Amoo on 5/4/25.
//


import Foundation

struct ProductSection: Identifiable {
    let id = UUID()
    let title: String
    let products: [Product]
}
