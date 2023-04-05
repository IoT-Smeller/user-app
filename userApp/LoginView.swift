//
//  LoginView.swift
//  userApp
//
//  Created by Jaden Ngo on 3/9/23.
//

import SwiftUI


struct LoginView: View {
    
    @EnvironmentObject var us: UserState
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @ObservedObject var user: UserObject
    
    var body: some View {
        ScrollView {
            VStack {
                Button("Get User") {
                    Task {
                        await getUser()
                    }
                }
                .bold()
                .padding()
                .foregroundColor(.white)
                .background(CustomColor.lightBlue)
                .cornerRadius(25)
                .offset(y: 275)
            }
        }
        .alert("Thank you!", isPresented: $showingConfirmation) {
                    Button("OK") { }
                } message: {
                    Text(confirmationMessage)
                }
    }
    
    func getUser() async {
        guard let encoded = try? JSONEncoder().encode(user) else {
            print("Failed to encode user")
            return
        }
        
        let url = URL(string: "http://iotsmeller.roshinator.com:8080/user")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedUser = try JSONDecoder().decode(UserObject.self, from: data)
           // user.user_id = decodedUser.user_id   **** CHANGE BACK ******
            user.user_id = "69696969-4200-4200-4200-696969696969"
            confirmationMessage = "User created: \(user.user_id)"
            showingConfirmation = true
            us.isLoggedIn = true
        } catch {
            print("Checkout failed.")
        }
    }
}
    

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(user: UserObject())
    }
}
