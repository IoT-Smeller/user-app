//
//  userAppApp.swift
//  userApp
//
//  Created by Colette Bradley on 2/2/23.
//

import SwiftUI

@main
struct userAppApp: App {
    @StateObject var selTab = SelectedTab()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(selTab)
        }
    }
}
