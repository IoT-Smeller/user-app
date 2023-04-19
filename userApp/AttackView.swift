//
//  DeviceView.swift
//  userApp
//
//  Created by Jaden Ngo on 1/26/23.
//

import SwiftUI
import Foundation

struct AttackView: View {
    let attack: AttackObject
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
                let statusColor = getColor(status: attack.severity)
                Text("\(attack.attack_type)").font(.title3)
                Image(systemName: "circle.fill").resizable().frame(width: 10, height: 10).foregroundColor(statusColor)
                Spacer()
                Text("\(attack.timestampString ?? "")")
                Spacer()
            }
            
            if isExpanded {
                VStack {
                    HStack {
                        Text("Affected Device: ").font(.subheadline)
                        Text("\(attack.device_name ?? "Unkown Name")").font(.subheadline)
                    }
                    if (attack.severity == "Attack") {
                        Text("Identified as an attack!").font(.subheadline)
                    } else if (attack.severity == "Warning") {
                        Text("Identified as an attack!").font(.subheadline)
                    }
                }
            }
        }
    }
    
    func getColor(status: String) -> Color {
        if (status == "Warning") {
            return .yellow
        } else if (status == "Attack") {
            return .red
        } else {
            return .gray
        }
    }
}

struct AttacksListView: View {
    let attacks: [AttackObject]
    @State private var selection: Set<AttackObject> = []

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
    
    private func selectDeselect(_ attack: AttackObject) {
        if selection.contains(attack) {
            selection.remove(attack)
        } else {
            closeOthers()
            selection.insert(attack)
        }
    }
    
    private func closeOthers() {
        selection.removeAll()
    }
}

struct AttacksList_Previews: PreviewProvider {
    static var previews: some View {
        let a: [AttackObject] = []
        AttacksListView(attacks: a)
    }
}

struct AttackPageView: View {
    //@Binding var activeTab: Int
    @EnvironmentObject var us: UserState
    @State private var confirmationMessageDevice = ""
    @State private var showingConfirmationDevice = false
    @State var attacks: [AttackObject] = []
    
    var body: some View {

            NavigationView {
                VStack {
                    Spacer()
                        .frame(height: 25)
                    
                    Image(systemName: "shield.lefthalf.filled").resizable().frame(width: 50, height: 50).foregroundColor(CustomColor.lightBlue)
                    Text("WARN")
                    Spacer()
                        .frame(height: 50)
                    
                    Text("Past 10 Days").bold().font(.title2)
                        .frame(maxWidth: 350, alignment: .leading)

                    //AttacksListView(attacks: Attack.todayAttacks())
                    AttacksListView(attacks: attacks.filter {$0.timestampDate! >= getDate(days: 10) } )
                    
                    Spacer()
                    
                    Text("Previous").bold().font(.title2)
                        .frame(maxWidth: 350, alignment: .leading)
                    
                    //AttacksListView(attacks: Attack.prevAttacks())
                    AttacksListView(attacks: attacks.filter {$0.timestampDate! < getDate(days: 10) } )
                    
                    
                    Text("\n")
                    
                }
                .background(CustomColor.lightGray)
            }.onAppear(perform: getAttackHistory)
        }
    
    func getAttackHistory() {
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/history?user_id=\(us.userid)&count=10") else { fatalError("Missing URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   print("Request error: ", error)
                   return
               }

            guard response is HTTPURLResponse else { return }

               if let data = data {
                   DispatchQueue.main.async {
                       do {
                           attacks = try JSONDecoder().decode([AttackObject].self, from: data)
                       } catch let error {
                           confirmationMessageDevice = "Error Decoding: \(error)"
                           showingConfirmationDevice = true
                       }
                   }
               }
           }
           dataTask.resume()
    }
     
    func getDate(days: Int) -> Date {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        
        let date = Date()
        let result = Calendar.current.date(byAdding: .day, value: -days, to: date)
        return result!
    }
}

struct AttackView_Previews: PreviewProvider {
    @State static var activeTab = 3
    
    static var previews: some View {
        AttackPageView().tag(3)
    }
}


/* References
 - Expandable list functionality inspired by: V8tr, https://github.com/V8tr/ExpandableListSwiftUI
 
 
 */
