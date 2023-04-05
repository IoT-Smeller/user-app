//
//  User.swift
//  userApp
//
//  Created by Jaden Ngo on 3/9/23.
//

import Foundation

class DeviceObject: ObservableObject, Codable, Identifiable, Hashable {
    
    // Device(id: 1, name: "Amazon Dot", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[2], krackVulnerability: vulnerabilities[2], attackID: [1]),
    
    enum CodingKeys: CodingKey {
            case device_id, user_id, connection_status, severity, device_manf, device_name, pps
    }

    @Published var device_id = ""
    @Published var user_id = ""
    @Published var connection_status = ""
    @Published var severity = ""
    @Published var device_manf = ""
    @Published var device_name = ""
    @Published var pps: Int = -1
    //@Published var devices: [Device] = []

    init() { }
    
    static func == (lhs: DeviceObject, rhs: DeviceObject) -> Bool {
        return lhs.device_id == rhs.device_id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(device_id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(device_id, forKey: .device_id)
        try container.encode(user_id, forKey: .user_id)
        try container.encode(connection_status, forKey: .connection_status)
        try container.encode(severity, forKey: .severity)
        try container.encode(device_manf, forKey: .device_manf)
        try container.encode(device_name, forKey: .device_name)
        try container.encode(pps, forKey: .pps)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        device_id = try container.decode(String.self, forKey: .device_id)
        user_id = try container.decode(String.self, forKey: .user_id)
        connection_status = try container.decode(String.self, forKey: .connection_status)
        severity = try container.decode(String.self, forKey: .severity)
        device_manf = try container.decode(String.self, forKey: .device_manf)
        device_name = try container.decode(String.self, forKey: .device_name)
        pps = try container.decode(Int.self, forKey: .pps)
        
        //devices = device_id.map{ Device(id: $0) }
    }

    
    
   /* enum CodingKeys: CodingKey {
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
        
    }*/
}
