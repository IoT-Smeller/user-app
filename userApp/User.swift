//
//  User.swift
//  userApp
//
//  Created by Jaden Ngo on 3/9/23.
//

import Foundation

class UserObject: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
            case user_id
    }

    @Published var user_id = ""

    init() { }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(user_id, forKey: .user_id)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user_id = try container.decode(String.self, forKey: .user_id)
        
    }
}
