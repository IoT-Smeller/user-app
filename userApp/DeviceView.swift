//
//  DeviceView.swift
//  userApp
//
//  Created by Jaden Ngo on 1/26/23.
//

import SwiftUI
import Foundation

public var vulnerabilities = ["Low", "Medium", "High"]

struct Device: Identifiable, Hashable {
    let id: Int
    let name: String
    let macAddr: String
    let status: Color
    let deauthVulnerability: String
    let krackVulnerability: String
    let attacked: Bool
    let attackID: Int
    
    static func allDevices() -> [Device] { // List of all devices connected at some point in time
        let allDevices: [Device] = [
            Device(id: 1, name: "Amazon Dot", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[2], krackVulnerability: vulnerabilities[2], attacked: false, attackID: 1),
            Device(id: 2, name: "Google Nest Hub", macAddr:  "00-B0-D0-63-C2-26", status: .yellow, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[0], attacked: false, attackID: 2),
            Device(id: 3, name: "Google Nest Camera", macAddr:  "00-B0-D0-63-C2-26", status: .red, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[1], attacked: false, attackID: 2),
            Device(id: 4, name: "August Lock", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[0], krackVulnerability: vulnerabilities[0], attacked: false, attackID: 3),
            Device(id: 1, name: "Google Thermostat", macAddr:  "00-B0-D0-63-C2-26", status: .gray, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[1], attacked: false, attackID: 4)
        ]
        
        return allDevices
    }
    
    static func connected() -> [Device] { // List of currently connected devices
        let connectedDevices: [Device] = [
            Device(id: 1, name: "Amazon Dot", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[2], krackVulnerability: vulnerabilities[2], attacked: false, attackID: 1),
            Device(id: 2, name: "Google Nest Hub", macAddr:  "00-B0-D0-63-C2-26", status: .yellow, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[0], attacked: false, attackID: 2),
            Device(id: 3, name: "Google Nest Camera", macAddr:  "00-B0-D0-63-C2-26", status: .red, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[1], attacked: false, attackID: 2),
            Device(id: 4, name: "August Lock", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[0], krackVulnerability: vulnerabilities[0], attacked: false, attackID: 3)
        ]
        
        return connectedDevices
    }
    
    static func other() -> [Device] { // List of devices not currently connected, detected by wifi
        @StateObject var attackId = SelectedAttack()
        
        let otherDevices: [Device] = [
            Device(id: 1, name: "Google Thermostat", macAddr:  "00-B0-D0-63-C2-26", status: .gray, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[1], attacked: false, attackID: -1)
        ]
        
        return otherDevices
    }
    
    static func attacked() -> [Device] { // TODO: for each connected device, if attack id = selected attack
        @StateObject var selectedAttackID = SelectedAttack()
        var attackedDevices: [Device] = []
        let allDevices: [Device] = allDevices()
        
        attackedDevices = allDevices.filter({$0.attackID == selectedAttackID.id})
        
        return attackedDevices
    }
}

struct DeviceView: View {
    let device: Device
    let isExpanded: Bool
    
    var body: some View {
        HStack {
            content
            Spacer()
        }
        .contentShape(Rectangle())
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(device.name).font(.title3)
                Image(systemName: "circle.fill").resizable().frame(width: 10, height: 10).foregroundColor(device.status)
            }
            
            if isExpanded {
                if device.attacked { // Only show certain info if device is attacked
                    VStack(alignment: .leading) {
                        Spacer()
                        HStack {
                            Text("MAC Address:")
                            Text(device.macAddr)
                        }
                    }
                } else {
                    VStack(alignment: .leading) { // Only show certain info if device isn't attacked
                        Spacer()
                        HStack {
                            Text("MAC Address:")
                            Text(device.macAddr)
                        }
                        HStack {
                            Text("Deauth Vulnerability:")
                            Text(device.deauthVulnerability)
                        }
                        HStack {
                            Text("KRACK Vulnerability:")
                            Text(device.krackVulnerability)
                        }
                    }
                }
            }
        }
    }
}

struct DevicesListView: View {
    let devices: [Device]
    @State private var selection: Set<Device> = []

    var body: some View {
        scrollForEach
            .background(.white)
    }
    
    var list: some View {
        List(devices) { device in
            DeviceView(device: device, isExpanded: self.selection.contains(device))
                .onTapGesture { self.selectDeselect(device) }
                .animation(.easeInOut(duration: 2), value: 1)
        }
    }
    
    var scrollForEach: some View {
        ScrollView {
            ForEach(devices) { device in
                DeviceView(device: device, isExpanded: self.selection.contains(device))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect(device) }
                    .animation(.easeInOut(duration: 2), value: 1)
            }
        }
    }
    
    private func selectDeselect(_ device: Device) {
        if selection.contains(device) {
            selection.remove(device)
        } else {
            closeOthers()
            selection.insert(device)
        }
    }
    
    private func closeOthers() {
        selection.removeAll()
    }
}

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            Spacer()
            Spacer()
            content
            Divider()
        }.offset(x: 20)
    }
}


struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        DevicesListView(devices: Device.connected())
    }
}

struct DevicePageView: View {
    var body: some View {

            NavigationView {
                VStack {
                    Spacer()
                        .frame(height: 25)
                    
                    Image(systemName: "shield.lefthalf.filled").resizable().frame(width: 50, height: 50).foregroundColor(CustomColor.lightBlue)
                    Text("WARN")
                    Spacer()
                        .frame(height: 50)
                    
                    Text("Connected Devices").bold().font(.title2)
                        .frame(maxWidth: 350, alignment: .leading)

                    DevicesListView(devices: Device.connected())
                    
                    Text("Other Devices").bold().font(.title2)
                        .frame(maxWidth: 350, alignment: .leading).offset()
                    Spacer()
                    DevicesListView(devices: Device.other())
                    
                    Text("\n")
                    
                }
                .background(CustomColor.lightGray)
            }
        }
        
     /*   func addDevice() {
            guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            // TODO: Add functionality to check status of new device connection
                // Add respective status color
                // Add device to list & remove from "Other Devices"
            
            let newDevice = Device(title: text, color: Color.green)
            viewModel.devices.append(newDevice)
            text = ""
        }
        
        func checkDeviceStatus() {
            // Updates device status icon based on network connectivity
        }
    }*/
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePageView()
    }
}


/* References
 - Expandable list functionality inspired by: V8tr, https://github.com/V8tr/ExpandableListSwiftUI
 
 
 */
