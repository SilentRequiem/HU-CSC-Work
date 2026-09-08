//
//  SignUpView.swift
//  HUCart
//
//  Created by Michael Amoo on 4/28/25.
//


import SwiftUI

struct User {
    let id = UUID()
    let name: String
    let email: String
}


struct SignUpView: View {
    @Binding var users: [String: String]
    @Environment(\.dismiss) var dismiss

    @State private var newUsername = ""
    @State private var newPassword = ""
    
    var body: some View {
        
        ZStack {
            Image("HU Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 5)
                .opacity(0.5)
            
            VStack(spacing: 3) {
                Text("Create Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                TextField("New Username", text: $newUsername)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, -900)
                    .frame(width:370, height: 100)
                

                SecureField("New Password", text: $newPassword)
                    
                    .textFieldStyle(.roundedBorder)
                    .frame(width:370, height: 100)
                    
                

                Button("Sign Up") {
                    if !newUsername.isEmpty && !newPassword.isEmpty {
                        users[newUsername] = newPassword
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .padding()
        }
        
        
    }
}

    #Preview {
        SignUpView(users: .constant(["student": "password"]))
            .preferredColorScheme(.light)
    }


