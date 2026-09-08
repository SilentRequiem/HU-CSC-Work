import Foundation

struct Store: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let deliveryTime: String
    let pickupTime: String
    let distance: String
    let cost: String
    let acceptsEBT: Bool
}

let sampleStores: [Store] = [
    Store(
        name: "Walmart",
        imageName: "Walmart",
        deliveryTime: "Delivery by 6:00pm",
        pickupTime: "Pickup in 50 min",
        distance: "0.8 mi",
        cost: "$",
        acceptsEBT: true
    ),
    Store(
        name: "H&M",
        imageName: "HM",
        deliveryTime: "Delivery by 5:30pm",
        pickupTime: "Pickup in 40 min",
        distance: "1.1 mi",
        cost: "$$",
        acceptsEBT: false
    ),
    Store(
        name: "Food Lion",
        imageName: "FoodLion",
        deliveryTime: "Delivery by 7:00pm",
        pickupTime: "Pickup in 60 min",
        distance: "1.4 mi",
        cost: "$",
        acceptsEBT: true
    ),
    Store(
        name: "Bath & Body Works",
        imageName: "BBW",
        deliveryTime: "Delivery by 6:45pm",
        pickupTime: "Pickup in 30 min",
        distance: "1.0 mi",
        cost: "$$",
        acceptsEBT: false
    )
]
