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
    static let selAttack = SelectedAttack()
    
    @Published var id: Int = 2
}

class attackObjs: ObservableObject {
    @Published var atts: [AttackObject] = []

      func getUsers() {
          guard let url = URL(string: "****") else { fatalError("Missing URL") }

          let urlRequest = URLRequest(url: url)

          let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
              if let error = error {
                  print("Request error: ", error)
                  return
              }

              guard let response = response as? HTTPURLResponse else { return }

              if response.statusCode == 200 {
                  guard let data = data else { return }
                  DispatchQueue.main.async {
                      do {
                          let decodedUsers = try JSONDecoder().decode([AttackObject].self, from: data)
                          self.atts = decodedUsers
                      } catch let error {
                          print("Error decoding: ", error)
                      }
                  }
              }
          }

          dataTask.resume()
      }
}

struct Attack: Identifiable, Hashable {
    let id: Int
    let name: String
    let timestamp: String
    
    static func todayAttacks() -> [Attack] {
        let todayAttacks: [Attack] = [
            Attack(id: 2, name: "Deauthentication", timestamp: "30m ago")
        ]
        
        return todayAttacks
    }
    
    static func prevAttacks() -> [Attack] {
        let prevAttacks: [Attack] = [
            Attack(id: 1, name: "Deauthentication", timestamp: "2d ago"),
            Attack(id: 3, name: "Deauthentication", timestamp: "4d ago")
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
    @ObservedObject var selectedAttack = SelectedAttack.selAttack
    //@StateObject var selectedAttack = SelectedAttack.id

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
    @Binding var activeTab: Int
    
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
    @State static var activeTab = 3
    
    static var previews: some View {
        AttackPageView(activeTab: $activeTab).tag(3)
    }
}


/* References
 - Expandable list functionality inspired by: V8tr, https://github.com/V8tr/ExpandableListSwiftUI
 
 
 */
