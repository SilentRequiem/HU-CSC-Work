import SwiftUI

struct AccountView: View {
    let username: String
    @Binding var selectedStore: Store?
    @EnvironmentObject var cartManager: CartManager
    @State private var shouldLogout = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome, \(username)!")
                    .font(.title2)
                    .fontWeight(.bold)

                (
                    Text("Email: ").foregroundColor(.gray) +
                    Text("\(username.lowercased())@myhamptonu.edu").foregroundColor(.blue)
                )

                // Order History Section
                Text("Order History")
                    .font(.title3)
                    .bold()
                    .padding(.top)

                if cartManager.orderHistory.isEmpty {
                    Text("No past orders.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(cartManager.orderHistory) { order in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Store: \(order.store.name)")
                                .font(.subheadline)
                                .foregroundColor(.blue)

                            Text("Order Date: \(order.date.formatted(date: .abbreviated, time: .shortened))")
                                .font(.headline)

                            Text("Total: $\(order.totalPrice, specifier: "%.2f")")
                                .font(.subheadline)

                            ForEach(order.products) { product in
                                Text("- \(product.name)")
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }

                NavigationLink(destination: LoginView(), isActive: $shouldLogout) {
                                    EmptyView()
                                }

                                Button(action: {
                                    shouldLogout = true
                                }) {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                        Text("Logout")
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal)

                                Spacer()
                            }
                            .padding()
                        }
                }
            }

#Preview {
    AccountView(username: "student", selectedStore: .constant(nil))
        .environmentObject(CartManager())
        .preferredColorScheme(.light)
}
