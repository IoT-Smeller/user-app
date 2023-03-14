//
//  User.swift
//  userApp
//
//  Created by Colette Bradley on 3/9/23.
//

import Foundation

class DeviceObject: ObservableObject, Codable {
    
    // Device(id: 1, name: "Amazon Dot", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[2], krackVulnerability: vulnerabilities[2], attackID: [1]),
    
    enum CodingKeys: CodingKey {
            case device_id, name, mac, status, deauthVulnerability, krackVulnerability, attackID
    }

    @Published var device_id = ""
    @Published var name = ""
    @Published var mac = ""
    @Published var status = ""
    @Published var deauthVulnerability = ""
    @Published var krackVulnerability = ""
    @Published var attackID = ""

    init() { }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(device_id, forKey: .device_id)
        try container.encode(name, forKey: .name)
        try container.encode(mac, forKey: .mac)
        try container.encode(status, forKey: .status)
        try container.encode(deauthVulnerability, forKey: .deauthVulnerability)
        try container.encode(krackVulnerability, forKey: .krackVulnerability)
        try container.encode(device_id, forKey: .device_id)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        device_id = try container.decode(String.self, forKey: .device_id)
        name = try container.decode(String.self, forKey: .name)
        mac = try container.decode(String.self, forKey: .mac)
        status = try container.decode(String.self, forKey: .status)
        deauthVulnerability = try container.decode(String.self, forKey: .deauthVulnerability)
        krackVulnerability = try container.decode(String.self, forKey: .krackVulnerability)
        attackID = try container.decode(String.self, forKey: .attackID)
        
    }
}
