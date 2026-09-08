import Foundation

class CartManager: ObservableObject {
    @Published var items: [Product] = []
    @Published var quantities: [UUID: Int] = [:]
    @Published var orderHistory: [Order] = []


/*
    func addToCart(product: Product) {
        items.append(product)
        quantities[product.id, default: 0] += 1
    }

    func removeFromCart(product: Product) {
        if let index = items.firstIndex(of: product) {
            items.remove(at: index)
            quantities[product.id, default: 1] -= 1
            if quantities[product.id] ?? 0 <= 0 {
                quantities.removeValue(forKey: product.id)
            }
        }
    }
 */

    func updateQuantity(for product: Product, increase: Bool) {
        if increase {
            addToCart(product: product)
        } else {
            removeFromCart(product: product)
        }
    }

    func clearCart() {
        items.removeAll()
        quantities.removeAll()
    }

    func totalPrice() -> Double {
        items.reduce(0) { result, product in
            let quantity = quantities[product.id] ?? 0
            return result + (product.price * Double(quantity))
        }
    }

    func checkout(from store: Store) {
        let grouped = Dictionary(grouping: items, by: { $0.id })
        let uniqueProducts = grouped.compactMap { $0.value.first }
        let total = totalPrice()
        let order = Order(store: store, products: uniqueProducts, date: Date(), totalPrice: total)
        orderHistory.append(order)
        clearCart()
    }
    
    func totalItemCount() -> Int {
        return quantities.values.reduce(0, +)
    }
    
    func addToCart(product: Product) {
            quantities[product.id, default: 0] += 1
            if !items.contains(product) {
                items.append(product)
            }
            objectWillChange.send()
        }

    func removeFromCart(product: Product) {
            if let count = quantities[product.id], count > 1 {
                quantities[product.id] = count - 1
            } else {
                quantities.removeValue(forKey: product.id)
                items.removeAll { $0.id == product.id }
            }
            objectWillChange.send()
        }

    

    var cartItems: [CartItem] {
        let grouped = Dictionary(grouping: items, by: { $0.id })
        return grouped.compactMap { (key, products) in
            guard let product = products.first else { return nil }
            let quantity = quantities[product.id] ?? 1
            return CartItem(product: product, quantity: quantity)
        }
    }
}
