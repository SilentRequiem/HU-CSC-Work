import SwiftUI

struct StoreSelectionView: View {
    @Binding var selectedStore: Store?
    @EnvironmentObject var cartManager: CartManager

    let stores: [Store] = sampleStores

    var body: some View {
        NavigationStack {
            List(stores) { store in
                Button {
                    selectedStore = store
                } label: {
                    HStack(alignment: .top) {
                        Image(store.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(store.name).font(.headline)
                            Text(store.deliveryTime).font(.subheadline).foregroundColor(.green)
                            Text(store.pickupTime).font(.caption).foregroundColor(.gray)

                            HStack(spacing: 6) {
                                Text(store.distance)
                                Text(store.cost)
                                if store.acceptsEBT {
                                    Text("EBT")
                                        .font(.caption2)
                                        .padding(4)
                                        .background(Color.yellow.opacity(0.7))
                                        .cornerRadius(4)
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Stores")
        }
    }
}

#Preview {
    StoreSelectionView(selectedStore: .constant(nil))
        .environmentObject(CartManager())
        .preferredColorScheme(.light)
}
