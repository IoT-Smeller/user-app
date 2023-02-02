//
//  ContentView.swift
//  userApp
//
//  Created by Jaden Ngo on 1/23/23.
//

import SwiftUI

// ********  Colors ********
struct CustomColor {
    static let naviColor = Color("navigationBar")
    static let lightBlue = Color("lightBlue")
    static let darkBlue = Color("darkBlue")
    static let lightGray = Color("lightGray")
}

// *** Content View ***
struct ContentView: View {
    var body: some View {
        TabView {
            DevicePageView()
                .tabItem {
                    Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                    Text("Devices")
                }
            
            NetworkView()
                .tabItem {
                    Image(systemName: "wifi")
                    Text("Network")
                }
            
            AttackView()
                .tabItem {
                     Image(systemName: "exclamationmark.triangle")
                     Text("Attacks")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
