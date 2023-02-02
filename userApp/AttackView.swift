//
//  DeviceView.swift
//  userApp
//
//  Created by Jaden Ngo on 1/26/23.
//

import SwiftUI
import Foundation

// vulnerabilities = ["Low", "Medium", "High"]

class SelectedAttack: ObservableObject {
    @Published var id = -1
}

struct Attack: Identifiable, Hashable {
    let id: Int
    let name: String
    let timestamp: String
    let affectedDevices: [Device]
    
    static func todayAttacks() -> [Attack] {
        let todayAttacks: [Attack] = [
            Attack(id: 1, name: "Deauth", timestamp: "30m ago", affectedDevices: [])
        ]
        
        return todayAttacks
    }
    
    static func prevAttacks() -> [Attack] {
        let prevAttacks: [Attack] = [
            Attack(id: 2, name: "Deauth", timestamp: "2d ago", affectedDevices: [])
        ]
        
        return prevAttacks
    }
}

struct AttackView: View {
    let attack: Attack
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
                Text(attack.name).font(.title3)
                Spacer()
                Text(attack.timestamp).font(.title3)
                Spacer()
            }
            
            if isExpanded {

                VStack(alignment: .leading) {
                    Spacer()
                    Text("Affected Devices:").font(.subheadline)
                    VStack {
                        DevicesListView(devices: Device.attacked()) // TODO: filter devices based on attack
                    }
                }
            }
        }
    }
}

struct AttacksListView: View {
    let attacks: [Attack]
    @State private var selection: Set<Attack> = []
    @StateObject var selectedAttack = SelectedAttack()

    var body: some View {
        scrollForEach
            .background(.white)
    }
    
    var list: some View {
        List(attacks) { attack in
            AttackView(attack: attack, isExpanded: self.selection.contains(attack))
                .onTapGesture { self.selectDeselect(attack) }
                .animation(.easeInOut(duration: 2), value: 1)
        }
    }
    
    var scrollForEach: some View {
        ScrollView {
            ForEach(attacks) { attack in
                AttackView(attack: attack, isExpanded: self.selection.contains(attack))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect(attack) }
                    .animation(.easeInOut(duration: 2), value: 1)
            }
        }
    }
    
    private func selectDeselect(_ attack: Attack) {
        if selection.contains(attack) {
            selection.remove(attack)
        } else {
            closeOthers()
            selection.insert(attack)
            selectedAttack.id = attack.id
        }
    }
    
    private func closeOthers() {
        selection.removeAll()
    }
}

struct AttacksList_Previews: PreviewProvider {
    static var previews: some View {
        AttacksListView(attacks: Attack.todayAttacks())
    }
}

struct AttackPageView: View {
    var body: some View {

            NavigationView {
                VStack {
                    Spacer()
                        .frame(height: 25)
                    
                    Image(systemName: "shield.lefthalf.filled").resizable().frame(width: 50, height: 50).foregroundColor(CustomColor.lightBlue)
                    Text("WARN")
                    Spacer()
                        .frame(height: 50)
                    
                    Text("Today").bold().font(.title2)
                        .frame(maxWidth: 350, alignment: .leading)

                    AttacksListView(attacks: Attack.todayAttacks())
                    
                    Spacer()
                    
                    Text("Previous").bold().font(.title2)
                        .frame(maxWidth: 350, alignment: .leading)
                    
                    AttacksListView(attacks: Attack.prevAttacks())
                    
                    
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

struct AttackView_Previews: PreviewProvider {
    static var previews: some View {
        AttackPageView()
    }
}


/* References
 - Expandable list functionality inspired by: V8tr, https://github.com/V8tr/ExpandableListSwiftUI
 
 
 */
