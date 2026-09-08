import SwiftUI

struct CartView: View {
    let store: Store
    @EnvironmentObject var cartManager: CartManager
    @State private var showCheckoutMessage = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Cart")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                if cartManager.cartItems.isEmpty {
                    Spacer()
                    Text("Your cart is empty.")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    List(cartManager.cartItems) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(item.product.name)
                                    .font(.headline)

                                Spacer()

                                Text("$\(item.product.price, specifier: "%.2f") each")
                                    .foregroundColor(.secondary)
                            }

                           /*
                            HStack(spacing: 20) {
                                Button(action: {
                                    cartManager.updateQuantity(for: item.product, increase: false)
                                }) {
                                    Image(systemName: "minus.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.red)
                                }

                                Text("\(item.quantity)")
                                    .frame(width: 30)
                                    .font(.headline)

                                Button(action: {
                                    cartManager.updateQuantity(for: item.product, increase: true)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                }
                            */
                                Spacer()
                                
                                Text("Total: $\(Double(item.quantity) * item.product.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 4)
                    }
                }

                VStack(spacing: 12) {
                    if !cartManager.cartItems.isEmpty {
                        Text("Total: $\(cartManager.totalPrice(), specifier: "%.2f")")
                            .font(.title3)
                            .bold()

                        Button("Checkout") {
                            showCheckoutMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                cartManager.checkout(from: store)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Button("Clear Cart") {
                            cartManager.clearCart()
                        }
                        .padding(.horizontal)
                        .foregroundColor(.red)
                    }

                    if showCheckoutMessage {
                        Text("✅ Thank you for your order!")
                            .foregroundColor(.green)
                            .font(.headline)
                            .transition(.opacity)
                            .padding(.top, 10)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.bottom, 80) // Prevent overlap with tab bar
        }
    }

