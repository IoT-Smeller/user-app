//
//  NetworkView.swift
//  userApp
//
//  Created by Jaden Ngo on 1/26/23.
//

import SwiftUI

// *** Network View ***
/*
 - Scan network for attacks
 - Overview of #attacks/week, etc.
 */

struct NetworkView: View {
    @EnvironmentObject var us: UserState
    @State var knownDevices: [DeviceObject] = []
    @State var statusColor: Color = Color.green
    
    var body: some View {
        let wifiName = "Phrog House"
    
        NavigationView {
            ZStack {
               VStack(spacing: 0) {
                   statusColor
                   CustomColor.lightGray
               }
               .edgesIgnoringSafeArea(.all)
               
               HStack {
                   Spacer().frame(width: 15)
                   Text("Wi-Fi Network").font(.title2).bold().foregroundColor(.white).frame(maxWidth: 340, alignment: .leading).offset(y: -330)
                   Image(systemName: "circle.fill").resizable().foregroundColor(CustomColor.lightGreen).frame(width: 25, height: 25).offset(y: -330)
                   Spacer().frame(width: 15)
               }
               
               Image(systemName: "wifi.circle").resizable().frame(width: 100, height: 100).foregroundColor(Color.white).offset(y: -175)
               Text(wifiName).font(.title2).bold().foregroundColor(.white).offset(y: -70)
                
                NavigationLink(destination: AddDeviceView()) {
                    Text("Add Device")
                }
                .padding()
                .background(CustomColor.lightBlue)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
                .position(x: 200, y: 450)
                
                NavigationLink(destination: RemoveDeviceView()) {
                    Text("Remove Device")
                }
                .padding()
                .background(.red)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
                .position(x: 200, y: 550)
                
                Spacer()
           }
       }.onAppear(perform: getConnectedDevices)
            .onAppear(perform: checkNetworkStatus)
    }
    
    func checkNetworkStatus() {
        statusColor = Color.green
        for d in knownDevices {
            if (d.severity == "Attack") {
                statusColor = Color.red
                return
            } else if (d.severity == "Warning") {
                statusColor = Color.yellow
            }
        }
    }
    
    func getConnectedDevices() {
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/device?user_id=\(us.userid)") else { fatalError("Missing URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   print("Request error: ", error)
                   return
               }

               guard let response = response as? HTTPURLResponse else { return }
 //           print(response.statusCode)

               if let data = data {
                   DispatchQueue.main.async {
                       do {
                           knownDevices = try JSONDecoder().decode([DeviceObject].self, from: data)
                      //     deviceInfo.knownDevices = knownDevices
                           deviceInfo.connectedDevices = knownDevices
                       } catch let error {
                          // confirmationMessageDevice = "Error Decoding: \(error)"
                          // showingConfirmationDevice = true
                           print("Error Decoding: \(error)")
                       }
                   }
               }
           }
           dataTask.resume()
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}
