//
//  userAppApp.swift
//  userApp
//
//  Created by Jaden Ngo on 2/2/23.d
//

import SwiftUI
import UserNotifications

@main
struct userAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
