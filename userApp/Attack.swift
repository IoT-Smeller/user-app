//
//  User.swift
//  userApp
//
//  Created by Jaden Ngo on 3/9/23.
//

import Foundation

class AttackObject: ObservableObject, Codable, Identifiable, Hashable {
    
    enum CodingKeys: CodingKey {
        case history_id, user_id, timestamp, attack_type, severity, device_address, device_name, convertedTimestamp
    }
    
    @Published var history_id = ""
    @Published var user_id = ""
    @Published var timestamp: [Int] = [] // year, day, hour, minute, second, nanosecond, offset hour, offset minute, offset second
    @Published var attack_type = ""
    @Published var severity = ""
    @Published var device_address = ""
    @Published var convertedTimestamp: String?
    @Published var device_name: String?
    
    init() { }
    
    static func == (lhs: AttackObject, rhs: AttackObject) -> Bool {
        return lhs.history_id == rhs.history_id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(history_id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(history_id, forKey: .history_id)
        try container.encode(user_id, forKey: .user_id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(attack_type, forKey: .attack_type)
        try container.encode(severity, forKey: .severity)
        try container.encode(device_address, forKey: .device_address)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        history_id = try container.decode(String.self, forKey: .history_id)
        user_id = try container.decode(String.self, forKey: .user_id)
        timestamp = try container.decode([Int].self, forKey: .timestamp)
        attack_type = try container.decode(String.self, forKey: .attack_type)
        severity = try container.decode(String.self, forKey: .severity)
        device_address = try container.decode(String.self, forKey: .device_address)
        convertedTimestamp = ""
      //  device_name = try container.decodeIfPresent(String.self, forKey: .device_name) ?? ""
        for d in deviceInfo.knownDevices {
            if d.device_id == device_address {
                device_name = d.device_name
            }
        }
    //    let dateFormatter = DateFormatter()
     //   timestampString = dateFormatter.string(from: date!)
        //timestampString = utcToLocal(dateStr: "\(timestamp[2]):\(timestamp[3]):\(timestamp[4])")
    }
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
