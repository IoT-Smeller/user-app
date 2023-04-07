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
    
    var body: some View { 
        let statusColor = checkNetworkStatus()
        let wifiName = "Phrog House"
    
        NavigationView {
            ZStack {
               VStack(spacing: 0) {
                   CustomColor.lightBlue
                   CustomColor.lightGray
               }
               .edgesIgnoringSafeArea(.all)
               
               HStack {
                   Text("Wi-Fi Network").font(.title2).bold().foregroundColor(.white).frame(maxWidth: 340, alignment: .leading).offset(y: -330)
                   Image(systemName: "circle.fill").resizable().foregroundColor(statusColor).frame(width: 25, height: 25).offset(y: -330)
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
                .position(x: 200, y: 600)
           }
       }
    }
    
    func checkNetworkStatus() -> Color {
        // TODO: check network connectivity and return corresponding icon color
        return Color.green
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}
