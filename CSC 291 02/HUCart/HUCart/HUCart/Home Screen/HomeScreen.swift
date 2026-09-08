import SwiftUI

struct HomeScreen: View {
    let store: Store
    @StateObject var homeVM = LocalHomeViewModel()
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome to \(store.name)")
                        .font(.largeTitle)
                        .bold()
                        .padding([.top, .leading])

                    ForEach(homeVM.sections(for: store)) { section in
                        VStack(alignment: .leading) {
                            Text(section.title)
                                .font(.title2)
                                .bold()
                                .padding(.leading)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(section.products) { product in
                                        NavigationLink {
                                            ProductDetailView(product: product)
                                                .environmentObject(cartManager)
                                        } label: {
                                            ProductCard(product: product)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    HomeScreen(store: Store(
        name: "Walmart",
        imageName: "Walmart",
        deliveryTime: "Delivery by 6:00pm",
        pickupTime: "Pickup in 50 min",
        distance: "0.8 mi",
        cost: "$",
        acceptsEBT: true
    ))
    .environmentObject(CartManager())
    .preferredColorScheme(.light)
}
