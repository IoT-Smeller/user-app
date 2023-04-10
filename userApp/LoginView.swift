//
//  LoginView.swift
//  userApp
//
//  Created by Jaden Ngo on 3/9/23.
//

import SwiftUI


struct LoginView: View {
    
    @EnvironmentObject var us: UserState
    @State private var userId = ""
    @State private var serverId = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmationMessage = false
    @ObservedObject var user: UserObject
    
    var isGetUserIDButtonDisabled: Bool {
            [serverId].contains(where: \.isEmpty)
        }
    
    var isSignInButtonDisabled: Bool {
            [userId].contains(where: \.isEmpty)
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer() // this use all space available above the TextField
            
            TextField("Server Id",
                      text: $serverId ,
                      prompt: Text("Server ID").foregroundColor(.red)
            )
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.red, lineWidth: 2)
            }
            .padding(.horizontal)
            
            Button {
                Task {
                    await getUser()
                }
                } label: {
                    Text("Get User ID")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    isGetUserIDButtonDisabled ?
                    LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.red], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .disabled(isGetUserIDButtonDisabled) // how to disable while some condition is applied
                .padding()
            
            Spacer()
            
            TextField("User Id",
                      text: $userId ,
                      prompt: Text("User ID").foregroundColor(.blue)
            )
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue, lineWidth: 2)
            }
            .padding(.horizontal)
            
            Button {
                    print("do login action")
                } label: {
                    Text("Sign In")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    isSignInButtonDisabled ?
                    LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [CustomColor.lightBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .disabled(isSignInButtonDisabled) // how to disable while some condition is applied
                .padding()
            
            Spacer()
        }.alert("Requested User ID", isPresented: $showingConfirmationMessage) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func getUser() async {
        let url = URL(string: "http://iotsmeller.roshinator.com:8080/user")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json: [String: String] = ["local_server_id": "69696969-4200-4200-4200-696969696969"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: String] {
                print(responseJSON)
                confirmationMessage = "Result: \(responseJSON)"
                showingConfirmationMessage = true
            }
        }
        dataTask.resume()
    }
}
    

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(user: UserObject())
    }
}

/*
 References:
 - Login Functionality: https://holyswift.app/how-to-create-a-login-screen-in-swiftui/
 */


    /* VStack {
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
         } */
