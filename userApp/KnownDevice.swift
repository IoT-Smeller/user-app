//
//  User.swift
//  userApp
//
//  Created by Jaden Ngo on 3/9/23.
//

import Foundation

class KnownDeviceObject: ObservableObject, Codable, Identifiable, Hashable {
    
    // Device(id: 1, name: "Amazon Dot", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[2], krackVulnerability: vulnerabilities[2], attackID: [1]),
    
    enum CodingKeys: CodingKey {
            case device_manf, device_name, pps
    }

    @Published var device_manf = ""
    @Published var device_name = ""
    @Published var pps: Int = -1
    @Published var devices: [UnkownDeviceObject]?

    init() { }
    
    static func == (lhs: KnownDeviceObject, rhs: KnownDeviceObject) -> Bool {
        return (lhs.device_manf == rhs.device_manf) && (lhs.device_name == rhs.device_name)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(device_manf)
        hasher.combine(device_name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(device_manf, forKey: .device_manf)
        try container.encode(device_name, forKey: .device_name)
        try container.encode(pps, forKey: .pps)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        device_manf = try container.decode(String.self, forKey: .device_manf)
        device_name = try container.decode(String.self, forKey: .device_name)
        pps = try container.decode(Int.self, forKey: .pps)
    }
}
