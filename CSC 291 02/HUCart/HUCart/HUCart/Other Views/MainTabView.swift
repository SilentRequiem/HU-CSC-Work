import SwiftUI

struct MainTabView: View {
    let store: Store
    let username: String
    @Binding var selectedStore: Store?

    @State private var selectedTab = 0
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case 0:
                        HomeScreen(store: store)
                    case 1:
                        CartView(store: store)
                    case 2:
                        AccountView(username: username, selectedStore: $selectedStore)
                    case 3:
                        StoreResetView(selectedStore: $selectedStore)
                    default:
                        HomeScreen(store: store)
                    }
                }
                .padding(.bottom, 80) // Pushes content above the tab bar

                // Tab Bar stays here
                HStack {
                    TabButton(title: "Home", icon: "house.fill", isSelected: selectedTab == 0) {
                        withAnimation { selectedTab = 0 }
                    }

                    TabButton(title: "Cart", icon: "cart.fill", isSelected: selectedTab == 1, badgeCount: cartManager.totalItemCount()) {
                        withAnimation { selectedTab = 1 }
                    }

                    TabButton(title: "Account", icon: "person.fill", isSelected: selectedTab == 2) {
                        withAnimation { selectedTab = 2 }
                    }

                    TabButton(title: "Stores", icon: "arrow.triangle.2.circlepath", isSelected: selectedTab == 3) {
                        withAnimation { selectedTab = 3 }
                    }
                }
                .padding()
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(radius: 5)
                .padding(.horizontal)
            }

        }
    }
}

#Preview {
    let exampleStore = Store(
        name: "Walmart",
        imageName: "Walmart",
        deliveryTime: "Delivery by 6:00pm",
        pickupTime: "Pickup in 50 min",
        distance: "0.8 mi",
        cost: "$",
        acceptsEBT: true
    )

    return MainTabView(
        store: exampleStore,
        username: "student",
        selectedStore: .constant(exampleStore)
    )
    .environmentObject(CartManager())
    .preferredColorScheme(.light)
}
