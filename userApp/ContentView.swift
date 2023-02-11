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

/*
 Active Tab Key:
    Devices: 1
    Network: 2
    Attacks: 3
 */

// *** Content View ***
struct ContentView: View {
    @State var activeTab = 1
    
    @EnvironmentObject var selTab: SelectedTab
    
    var body: some View {
        TabView (selection: $selTab.id){
            DevicePageView().tag(1)
                .tabItem {
                    Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                    Text("Devices")
                }
            
            NetworkView()
                .tabItem {
                    Image(systemName: "wifi")
                    Text("Network")
                }
            
            AttackPageView(activeTab: $activeTab).tag(3)
                .tabItem {
                     Image(systemName: "exclamationmark.triangle")
                     Text("Attacks")
                }
        }
    }
    
    func loadData() {
        // TODO: decode JSON from remote server 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SelectedTab())
    }
}
