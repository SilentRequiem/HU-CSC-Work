//
//  LocalHomeViewModel.swift
//  HUCart
//
//  Created by Michael Amoo on 5/4/25.
//


import SwiftUI

class LocalHomeViewModel: ObservableObject {
    func sections(for store: Store) -> [ProductSection] {
        switch store.name {
        case "Walmart":
            return [
                ProductSection(title: "Groceries", products: walmartGroceries),
                ProductSection(title: "Supplies", products: walmartSupplies)
            ]
        case "H&M":
            return [
                ProductSection(title: "Clothing", products: hmClothing)
            ]
        case "Food Lion":
            return [
                ProductSection(title: "Fresh Produce", products: foodlionProduce),
                ProductSection(title: "Snacks", products: foodlionSnacks)
            ]
        case "Bath & Body Works":
            return [
                ProductSection(title: "Fragrance", products: bbwFragrance),
                ProductSection(title: "Body Care", products: bbwBodyCare)
            ]
        default:
            return []
        }
    }

    var walmartGroceries: [Product] = [
        Product(name: "Milk", price: 3.49, imageName: "milk", description: "Fresh 2% milk."),
        Product(name: "Bread", price: 2.99, imageName: "bread", description: "Soft white bread.")
    ]

    var walmartSupplies: [Product] = [
        Product(name: "Notebook", price: 2.99, imageName: "notebook", description: "College ruled."),
        Product(name: "Pens", price: 1.99, imageName: "pens", description: "Smooth ink.")
    ]

    var hmClothing: [Product] = [
        Product(name: "Hoodie", price: 24.99, imageName: "hoodie", description: "Comfy & warm."),
        Product(name: "Jeans", price: 39.99, imageName: "jeans", description: "Slim fit denim.")
    ]

    var foodlionProduce: [Product] = [
        Product(name: "Bananas", price: 0.59, imageName: "banana", description: "Fresh and ripe."),
        Product(name: "Apples", price: 1.99, imageName: "apple", description: "Organic Apples.")
    ]

    var foodlionSnacks: [Product] = [
        Product(name: "Chips", price: 2.49, imageName: "chips", description: "Crunchy snack."),
        Product(name: "Cookies", price: 3.49, imageName: "cookies", description: "Chocolate chip.")
    ]

    var bbwFragrance: [Product] = [
        Product(name: "Candle", price: 14.99, imageName: "candle", description: "3-wick candle."),
        Product(name: "Perfume", price: 29.99, imageName: "perfume", description: "Sweet floral.")
    ]

    var bbwBodyCare: [Product] = [
        Product(name: "Lotion", price: 12.99, imageName: "lotion", description: "Smooth & hydrating."),
        Product(name: "Body Wash", price: 10.99, imageName: "bodywash", description: "Scented soap.")
    ]
}
