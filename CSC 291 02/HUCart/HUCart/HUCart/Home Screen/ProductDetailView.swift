import SwiftUI

struct ProductDetailView: View {
    let product: Product
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cartManager: CartManager
    @State private var quantity = 1
    @State private var showAddedMessage = false




    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding()

                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text(String(format: "$%.2f", product.price))
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Divider()
                    .padding()

                Text("Product Details")
                    .font(.headline)
                    .padding(.horizontal)

                Text(product.description)
                    .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        if quantity > 1 {
                            quantity -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.title)
                            .foregroundColor(.red)
                    }

                    Text("\(quantity)")
                        .font(.title2)
                        .frame(width: 50)

                    Button(action: {
                        quantity += 1
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(.green)
                    }

                    Spacer()

                    Text(String(format: "Total: $%.2f", product.price * Double(quantity)))
                        .font(.title3)
                        .bold()
                }
                .padding(.horizontal)
                .padding(.top)

                
                Button(action: {
                    for _ in 0..<quantity {
                        cartManager.addToCart(product: product)
                    }
                    showAddedMessage = true
                }) {
                    Text("Add \(quantity) to Cart")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .alert("✅ Added to Cart!", isPresented: $showAddedMessage) {
                    Button("OK", role: .cancel) { }
                }




                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .padding()
        })
    }
}

#Preview {
    let sampleProduct = Product(
        name: "Notebook",
        price: 2.99,
        imageName: "notebook",
        description: "Perfect for taking notes in class. Comes in multiple colors and paper styles."
    )

    return NavigationStack {
        ProductDetailView(product: sampleProduct)
    }
}

