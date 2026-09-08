import Foundation

struct CartItem: Identifiable, Hashable {
    let id = UUID()
    let product: Product
    let quantity: Int
}

