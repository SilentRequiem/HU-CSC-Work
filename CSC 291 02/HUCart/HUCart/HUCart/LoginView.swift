import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var selectedStore: Store? = nil
    @State private var users = ["student": "password"]
    @State private var showUsernameError: Bool = false
    @State private var showPasswordError: Bool = false
    @StateObject private var cartManager = CartManager()

    var body: some View {
        if let store = selectedStore {
            MainTabView(store: store, username: username, selectedStore: $selectedStore)
                .environmentObject(cartManager)
        } else if isLoggedIn {
            StoreSelectionView(selectedStore: $selectedStore)
                .environmentObject(cartManager)
        } else {
            NavigationStack {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                    Circle().scale(1.35).foregroundColor(.white)

                    VStack {
                        Image("hucart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)

                        Text("Welcome to HUCart")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)

                        TextField("Username", text: $username)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(showUsernameError ? Color.red : Color.gray, lineWidth: 1)
                            )
                            .cornerRadius(10)
                            .padding(.bottom, 20)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(showPasswordError ? Color.red : Color.gray, lineWidth: 1)
                            )
                            .cornerRadius(10)
                            .padding(.bottom, 20)

                        Button("Login") {
                            if let match = users.first(where: { $0.key.lowercased() == username.lowercased() }) {
                                showUsernameError = false
                                if match.value == password {
                                    showPasswordError = false
                                    isLoggedIn = true
                                } else {
                                    showPasswordError = true
                                }
                            } else {
                                showUsernameError = true
                                showPasswordError = false
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)

                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)

                            NavigationLink(destination: SignUpView(users: $users)) {
                                Text("Create an Account")
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        LoginView()
            .preferredColorScheme(.light)
    }
}
