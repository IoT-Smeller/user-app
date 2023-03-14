//
//  UserState.swift
//  userApp
//
//  Created by Colette Bradley on 3/14/23.
//

import Foundation

@MainActor
class UserState: ObservableObject {
    
    @Published var isLoggedIn = false
    
}
