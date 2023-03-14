//
//  userAppApp.swift
//  userApp
//
//  Created by Colette Bradley on 2/2/23.
//

import SwiftUI

@main
struct userAppApp: App {
    @StateObject var us = UserState()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ApplicationSwitcher()
            }.environmentObject(us)
        }
    }
}

struct ApplicationSwitcher: View {
    
    @StateObject var selTab = SelectedTab()
    @StateObject var user = UserObject()
    @EnvironmentObject var vm: UserState
    
    var body: some View {
        if (vm.isLoggedIn) {
                ContentView()
                    .environmentObject(selTab)
        } else {
            LoginView(user: user)
        }
        
    }
}
