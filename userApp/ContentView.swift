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
    @EnvironmentObject var attackobjs: attackObjs
   // @EnvironmentObject var userObjs: UserObject
    @StateObject var user = UserObject()
    
    var body: some View {
        TabView (selection: $selTab.id){
            DevicePageView().tag(1)
                .tabItem {
                    Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                    Text("Devices")
                }.environmentObject(selTab)
            
            NetworkView().tag(2)
                .tabItem {
                    Image(systemName: "wifi")
                    Text("Network")
                }
            
            AttackPageView(activeTab: $activeTab).tag(3)
                .tabItem {
                     Image(systemName: "exclamationmark.triangle")
                     Text("Attacks")
                }
            
            LoginView(user: user).tag(4)
                .tabItem {
                    Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                    Text("Login")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SelectedTab())
            .environmentObject(attackObjs())
            .environmentObject(UserObject())
    }
}
