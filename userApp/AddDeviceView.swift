//
//  AddDeviceView.swift
//  userApp
//
//  Created by Colette Bradley on 4/7/23.
//

import SwiftUI

struct AddDeviceView: View {
    @EnvironmentObject var us: UserState
    @State var unknownDevices: [UnkownDeviceObject] = []
    @State var KnownDevices: [KnownDeviceObject] = []
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 25)
            
            Image(systemName: "shield.lefthalf.filled").resizable().frame(width: 50, height: 50).foregroundColor(CustomColor.lightBlue)
            Text("WARN")
            Spacer()
                .frame(height: 50)
            
            Text("Select Manufacturer").bold().font(.title2)
                .frame(maxWidth: 350, alignment: .leading).offset()
            Spacer()
            
            NewDevicesListView(ukd: unknownDevices, ald: KnownDevices)
            
            Text("\n")
            
        }.onAppear(perform: getUnkownDevices)
            .onAppear(perform: getAllDevices)
    }
    
    func getUnkownDevices() {
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
                           print(error)
                       }
                   }
               }
           }
           dataTask.resume()
    }
    
    func getAllDevices() {
        guard let url = URL(string: "http://iotsmeller.roshinator.com:8080/info?user_id=\(us.userid)&prefix=69:69:69") else { fatalError("Missing URL") }

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
                           KnownDevices = try JSONDecoder().decode([KnownDeviceObject].self, from: data)
                       } catch let error {
                           print(error)
                       }
                   }
               }
           }
           dataTask.resume()
    }

}

struct KnownDeviceView: View {
    let device: KnownDeviceObject
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
            
            NavigationLink(destination: AddDeviceView2(selectedManufacturer: device)) {
                Text("\(device.manf_name)").font(.title3).foregroundColor(.black)
                Image(systemName: "circle.fill").resizable().frame(width: 10, height: 10).foregroundColor(.gray)
            }
        }
    }
}

struct NewDevicesListView: View {
    let ukd: [UnkownDeviceObject]
    let ald: [KnownDeviceObject]
    @State private var selection: Set<KnownDeviceObject> = []

    var body: some View {
        scrollForEach
            .background(.white)
    }
    
    var list: some View {
        List(ald) { device in
            KnownDeviceView(device: device, isExpanded: self.selection.contains(device))
                .animation(.easeInOut(duration: 2), value: 1)
        }
    }
    
    var scrollForEach: some View {
        ScrollView {
            ForEach(ald) { device in
                KnownDeviceView(device: device, isExpanded: self.selection.contains(device))
                    .modifier(ListRowModifier())
                    .animation(.easeInOut(duration: 2), value: 1)
            }
        }
    }
    
    private func selectDeselect(_ device: KnownDeviceObject) {
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
