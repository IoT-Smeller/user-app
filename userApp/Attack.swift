//
//  User.swift
//  userApp
//
//  Created by Colette Bradley on 3/9/23.
//

import Foundation

class AttackObject: ObservableObject, Codable {
    
    // Attack(id: 2, name: "Deauthentication", timestamp: "30m ago")
    
    enum CodingKeys: CodingKey {
            case attack_id, name, timestamp
    }

    @Published var attack_id = ""
    @Published var name = ""
    @Published var timestamp = ""
    
    init() { }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(attack_id, forKey: .attack_id)
        try container.encode(name, forKey: .name)
        try container.encode(timestamp, forKey: .timestamp)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        attack_id = try container.decode(String.self, forKey: .attack_id)
        name = try container.decode(String.self, forKey: .name)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        
    }
}
