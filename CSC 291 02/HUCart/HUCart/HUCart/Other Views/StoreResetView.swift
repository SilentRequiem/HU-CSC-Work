//
//  StoreResetView.swift
//  HUCart
//
//  Created by Michael Amoo on 5/4/25.
//


import SwiftUI

struct StoreResetView: View {
    @Binding var selectedStore: Store?
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Switch Stores?")
                .font(.title2)
                .bold()

            Text("This will clear your cart and take you back to the store selection screen.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Change Store") {
                cartManager.clearCart()
                selectedStore = nil
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }
}
