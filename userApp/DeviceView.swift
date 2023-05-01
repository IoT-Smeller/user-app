//
//  DeviceView.swift
//  userApp
//
//  Created by Jaden Ngo on 1/26/23.
//

import SwiftUI
import Foundation

struct deviceInfo {
    static var knownDevices: [KnownDeviceObject] = []
    static var unknownDevices: [UnkownDeviceObject] = []
    static var connectedDevices: [DeviceObject] = []
}

class SelectedTab: ObservableObject {
    @Published var id: Int
    
    init () {
        self.id = 1
    }
    
    func setTab(num: Int) {
        self.id = num
    }
}

struct DeviceView: View {
    let device: DeviceObject
    let isExpanded: Bool
    
    @EnvironmentObject var selTab: SelectedTab
    
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
                let statusColor = getColor(status: device.connection_status)
                Text("\(device.device_name)").font(.title3)
                Image(systemName: "circle.fill").resizable().frame(width: 10, height: 10).foregroundColor(statusColor)
            }
            
            if isExpanded {
                if (selTab.id == 3) { // Only show certain info if device is attacked
                    VStack(alignment: .leading) {
                        Spacer()
                      /*  HStack {
                            Text("Manufacturer: \(device.device_manf)")
                        }*/
                    }
                } else {
                    VStack(alignment: .leading) { // Only show certain info if device isn't attacked
                        Spacer()
                        /*HStack {
                            Text("Manufacturer: \(device.device_manf)")
                        }*/
                        HStack {
                            Text("Status: \(device.connection_status)")
                        }
                    }
                }
            }
        }
    }
    
    func getColor(status: String) -> Color {
        if (status == "Online") {
            return .green
        } else if (status == "Offline") {
            return .red
        } else {
            return .gray
        }
    }
}

struct UnkownDeviceView: View {
    let device: UnkownDeviceObject
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
                Text("\(device.device_name ?? "Unkown Name")").font(.title3)
                Image(systemName: "circle.fill").resizable().frame(width: 10, height: 10).foregroundColor(.gray)
            }
        }
    }
}

struct DevicesListView: View {
    let devices: [DeviceObject]
    @State private var selection: Set<DeviceObject> = []

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
    
    private func selectDeselect(_ device: DeviceObject) {
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

struct UnknownDevicesListView: View {
    let ukd: [UnkownDeviceObject]
    @State private var selection: Set<UnkownDeviceObject> = []

    var body: some View {
        scrollForEach
            .background(.white)
    }
    
    var list: some View {
        List(ukd) { device in
            UnkownDeviceView(device: device, isExpanded: self.selection.contains(device))
                .onTapGesture { self.selectDeselect(device) }
                .animation(.easeInOut(duration: 2), value: 1)
        }
    }
    
    var scrollForEach: some View {
        ScrollView {
            ForEach(ukd) { device in
                UnkownDeviceView(device: device, isExpanded: self.selection.contains(device))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect(device) }
                    .animation(.easeInOut(duration: 2), value: 1)
            }
        }
    }
    
    private func selectDeselect(_ device: UnkownDeviceObject) {
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
        let d: [DeviceObject] = []
        DevicesListView(devices: d)
    }
}

struct DevicePageView: View {
   // @Binding var activeTab: Int
   // @ObservedObject var selectedTab = activeTab
    @EnvironmentObject var us: UserState
    @State private var confirmationMessageDevice = ""
    @State private var showingConfirmationDevice = false
    @State var knownDevices: [DeviceObject] = []
    @State var unknownDevices: [UnkownDeviceObject] = []
    
    var body: some View {

            NavigationView {
                VStack {
                    Spacer()
                        .frame(height: 25)
                    
                    Image(systemName: "shield.lefthalf.filled").resizable().frame(width: 50, height: 50).foregroundColor(CustomColor.lightBlue)
                    Text("WARN").bold()
                    Spacer()
                        .frame(height: 50)
                    
                    Text("Connected Devices").bold().font(.title2)
                        .frame(maxWidth: 350, alignment: .leading)

                    DevicesListView(devices: knownDevices)
                    
                    Text("Other Devices").bold().font(.title2)
                        .frame(maxWidth: 350, alignment: .leading).offset()
                    Spacer()
                    
                    UnknownDevicesListView(ukd: unknownDevices)
                    
                    Text("\n")
                    
                }
                .background(CustomColor.lightGray)
                .alert("Connected Devices!", isPresented: $showingConfirmationDevice) {
                            Button("OK") { }
                        } message: {
                            Text(confirmationMessageDevice)
                        }
            }.onAppear(perform: getConnectedDevices)
            .onAppear(perform: getUnkownDevices)
    }
    
    
    func getConnectedDevices() {
        print(notificationInfo.token)
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/device?user_id=\(us.userid)") else { fatalError("Missing URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   print("Request error: ", error)
                   return
               }

               guard let response = response as? HTTPURLResponse else { return }
 //           print(response.statusCode)

               if let data = data {
                   DispatchQueue.main.async {
                       do {
                           knownDevices = try JSONDecoder().decode([DeviceObject].self, from: data)
                      //     deviceInfo.knownDevices = knownDevices
                           deviceInfo.connectedDevices = knownDevices
                       } catch let error {
                           confirmationMessageDevice = "Error Decoding: \(error)"
                           showingConfirmationDevice = true
                       }
                   }
               }
           }
           dataTask.resume()
    }
    
    func getUnkownDevices() {
        print("User id (in device view): \(us.userid)")
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/unknown-device?user_id=\(us.userid)") else { fatalError("Missing URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   print("Request error: ", error)
                   return
               }

               if let data = data {
                   DispatchQueue.main.async {
                       do {
                           unknownDevices = try JSONDecoder().decode([UnkownDeviceObject].self, from: data)
                           deviceInfo.unknownDevices = unknownDevices
                       } catch let error {
                           confirmationMessageDevice = "Error Decoding: \(error)"
                           showingConfirmationDevice = true
                       }
                   }
               }
           }
           dataTask.resume()
    }
}

struct DeviceView_Previews: PreviewProvider {
    @State static var activeTab = 1
    
    static var previews: some View {
        DevicePageView().tag(1)
    }
}


/* References
 - Expandable list functionality inspired by: V8tr, https://github.com/V8tr/ExpandableListSwiftUI
 

 //
 //  DeviceView.swift
 //  userApp
 //
 //  Created by Jaden Ngo on 1/26/23.
 //

 import SwiftUI
 import Foundation

 public var vulnerabilities = ["Low", "Medium", "High"]

 class SelectedTab: ObservableObject {
     @Published var id: Int
     
     init () {
         self.id = 1
     }
     
     func setTab(num: Int) {
         self.id = num
     }
 }

 struct Device: Identifiable, Hashable {
     let id: Int
     let name: String
     let macAddr: String
     let status: Color
     let deauthVulnerability: String
     let krackVulnerability: String
     let attackID: [Int]
     
     static func allDevices() -> [Device] { // List of all devices connected at some point in time
         let allDevices: [Device] = [
             Device(id: 1, name: "Amazon Dot", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[2], krackVulnerability: vulnerabilities[2], attackID: [1]),
             Device(id: 2, name: "Google Nest Hub", macAddr:  "00-B0-D0-63-C2-26", status: .yellow, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[0], attackID: [2]),
             Device(id: 3, name: "Google Nest Camera", macAddr:  "00-B0-D0-63-C2-26", status: .red, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[1], attackID: [2]),
             Device(id: 4, name: "August Lock", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[0], krackVulnerability: vulnerabilities[0], attackID: [3]),
             Device(id: 1, name: "Google Thermostat", macAddr:  "00-B0-D0-63-C2-26", status: .gray, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[1], attackID: [4])
         ]
         
         return allDevices
     }
     
     static func connected() -> [Device] { // List of currently connected devices
         let connectedDevices: [Device] = [
             Device(id: 1, name: "Amazon Dot", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[2], krackVulnerability: vulnerabilities[2], attackID: [1]),
             Device(id: 2, name: "Google Nest Hub", macAddr:  "00-B0-D0-63-C2-26", status: .yellow, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[0], attackID: [2]),
             Device(id: 3, name: "Google Nest Camera", macAddr:  "00-B0-D0-63-C2-26", status: .red, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[1], attackID: [2]),
             Device(id: 4, name: "August Lock", macAddr:  "00-B0-D0-63-C2-26", status: .green, deauthVulnerability: vulnerabilities[0], krackVulnerability: vulnerabilities[0], attackID: [3])
         ]
         
         return connectedDevices
     }
     
     static func other() -> [Device] { // List of devices not currently connected, detected by wifi
         @StateObject var attackId = SelectedAttack()
         
         let otherDevices: [Device] = [
             Device(id: 1, name: "Google Thermostat", macAddr:  "00-B0-D0-63-C2-26", status: .gray, deauthVulnerability: vulnerabilities[1], krackVulnerability: vulnerabilities[1], attackID: [-1])
         ]
         
         return otherDevices
     }
     
     static func attacked() -> [Device] { // TODO: for each connected device, if attack id = selected attack
         @ObservedObject var selectedAttack = SelectedAttack.selAttack
         var attackedDevices: [Device] = []
         let allDevices: [Device] = allDevices()
         
         attackedDevices = allDevices.filter({$0.attackID.contains(selectedAttack.id)})
         
         return attackedDevices
     }
 }

 struct DeviceView: View {
     let device: Device
     let isExpanded: Bool
     
     @EnvironmentObject var selTab: SelectedTab
     
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
                 if (selTab.id == 3) { // Only show certain info if device is attacked
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
    // @Binding var activeTab: Int
    // @ObservedObject var selectedTab = activeTab
     
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
     @State static var activeTab = 1
     
     static var previews: some View {
         DevicePageView().tag(1)
     }
 }


 /* References
  - Expandable list functionality inspired by: V8tr, https://github.com/V8tr/ExpandableListSwiftUI
  
  
  */
 */
