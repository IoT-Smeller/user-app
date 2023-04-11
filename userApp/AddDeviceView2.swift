//
//  AddDeviceView.swift
//  userApp
//
//  Created by Jaden Ngo on 4/7/23.
//

import SwiftUI

struct AddDeviceView2: View {
    var selectedManufacturer: KnownDeviceObject
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 25)
            
            Image(systemName: "shield.lefthalf.filled").resizable().frame(width: 50, height: 50).foregroundColor(CustomColor.lightBlue)
            Text("WARN")
            Spacer()
                .frame(height: 50)
            
            Text("Select Device With Manufacturer: ").bold().font(.title2)
                .frame(maxWidth: 350, alignment: .leading).offset()
            Text("\(selectedManufacturer.device_name)").bold().font(.title2).frame(maxWidth: 350, alignment: .center).offset().foregroundColor(CustomColor.lightBlue)
            Spacer()
            
            UnknownDevicesListView2(ukd: selectedManufacturer.devices!, sm: selectedManufacturer)
            
            Text("\n")
            
        }
    }
}

struct UnknownDevicesListView2: View {
    let ukd: [UnkownDeviceObject]
    let sm: KnownDeviceObject
    @State private var selection: Set<UnkownDeviceObject> = []

    var body: some View {
        scrollForEach
            .background(.white)
    }
    
    var list: some View {
        List(ukd) { device in
            UnkownDeviceView(device: device, isExpanded: self.selection.contains(device))
                .onTapGesture { self.addDevice(device) }
                .animation(.easeInOut(duration: 2), value: 1)
        }
    }
    
    var scrollForEach: some View {
        ScrollView {
            ForEach(ukd) { device in
                UnkownDeviceView(device: device, isExpanded: self.selection.contains(device))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.addDevice(device) }
                    .animation(.easeInOut(duration: 2), value: 1)
            }
        }
    }
    
    func addDevice(_ device: UnkownDeviceObject) {
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/device") else { fatalError("Missing URL") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json: [String: Any] = [
            "device_id": device.device_id,
            "user_id": device.user_id,
            "connection_status": "Offline",
            "severity": "Attack",
            "device_manf": sm.device_manf,
            "device_name": device.device_name ?? ""
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
}

struct AddDeviceView2_Previews: PreviewProvider {
    @State static var d = deviceInfo.knownDevices[0]
    
    static var previews: some View {
        AddDeviceView2(selectedManufacturer: d)
    }
}
