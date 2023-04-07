//
//  AddDeviceView.swift
//  userApp
//
//  Created by Colette Bradley on 4/7/23.
//

import SwiftUI

struct AddDeviceView: View {
    @State var unknownDevices: [UnkownDeviceObject] = []
    @State var allKnownDevices: [DeviceObject] = []
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 25)
            
            Image(systemName: "shield.lefthalf.filled").resizable().frame(width: 50, height: 50).foregroundColor(CustomColor.lightBlue)
            Text("WARN")
            Spacer()
                .frame(height: 50)
            
            Text("Add Device").bold().font(.title2)
                .frame(maxWidth: 350, alignment: .leading).offset()
            Spacer()
            
            NewDevicesListView(ukd: unknownDevices, ald: allKnownDevices)
            
            Text("\n")
            
        }.onAppear(perform: getUnkownDevices)
            .onAppear(perform: getAllDevices)
    }
    
    func getUnkownDevices() {
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/unknown-device?user_id=69696969-4200-4200-4200-696969696969") else { fatalError("Missing URL") }

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
                           print(error)
                       }
                   }
               }
           }
           dataTask.resume()
    }
    
    func getAllDevices() {
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/device?user_id=69696969-4200-4200-4200-696969696969&prefix=69:69:69") else { fatalError("Missing URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   print("Request error: ", error)
                   return
               }

               guard let response = response as? HTTPURLResponse else { return }
            print(response.statusCode)

               if let data = data {
                   DispatchQueue.main.async {
                       do {
                           allKnownDevices = try JSONDecoder().decode([DeviceObject].self, from: data)
                       } catch let error {
                           print(error)
                       }
                   }
               }
           }
           dataTask.resume()
    }
}

struct NewDeviceView: View {
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

struct NewDevicesListView: View {
    let ukd: [UnkownDeviceObject]
    let ald: [DeviceObject]
    @State private var selection: Set<UnkownDeviceObject> = []

    var body: some View {
        scrollForEach
            .background(.white)
    }
    
    var list: some View {
        List(ukd) { device in
            UnkownDeviceView(device: device, isExpanded: self.selection.contains(device))
                .onTapGesture { self.findDevice(device) }
                .animation(.easeInOut(duration: 2), value: 1)
        }
    }
    
    var scrollForEach: some View {
        ScrollView {
            ForEach(ukd) { device in
                UnkownDeviceView(device: device, isExpanded: self.selection.contains(device))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.findDevice(device) }
                    .animation(.easeInOut(duration: 2), value: 1)
            }
        }
    }
    
    private func findDevice(_ device: UnkownDeviceObject) {
        for d in ald {
            if (d.device_id == device.device_id) {
                addDevice(device: d)
            }
        }
    }
    
    func addDevice(device: DeviceObject) {
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/device") else { fatalError("Missing URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json: [String: Any] = [
            "device_id": device.device_id,
            "user_id": device.user_id,
            "connection_status": device.connection_status,
            "severity": device.severity,
            "device_manf": device.device_manf,
            "device_name": device.device_name
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
       }
       dataTask.resume()
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

struct AddDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeviceView()
    }
}
