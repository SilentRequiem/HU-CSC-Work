//
//  ProductCard.swift
//  HUCart
//
//  Created by Michael Amoo on 5/4/25.
//


import SwiftUI

struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(spacing: 8) {
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            Text(product.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)

            Text("$\(String(format: "%.2f", product.price))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 140)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

#Preview {
    ProductCard(product: Product(
        name: "Notebook",
        price: 2.99,
        imageName: "notebook",
        description: "College ruled notebook."
    ))
}
