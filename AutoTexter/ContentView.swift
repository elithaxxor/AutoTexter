//
//  ContentView.swift
//  AutoTexter
//
//  Created by Adel Al-Aali on 4/7/24.
//

import SwiftUI


struct ContentView: View {
    @State var thermalState = ""
    @State var date = Date.now
    @State var time = Date.timeIntervalSinceReferenceDate
    @State private var selectedDate = Date()
    
    @State  var phonenumber: String = ""
    @State  var message: String = ""

    
    // Try this if data flow doesnt work properly
    @StateObject var watchConnector = PhoneToWatchDataSender() // Inits watch data class
    
    @StateObject var messageLogic = ScheduleMessageLogic()
    
    func sendData() {
        print("[!] SENDING DATA TO WATCH")
        print("PH \($phonenumber.wrappedValue)",
              "MSG \($message.wrappedValue)",
              "\(selectedDate)")
        
        
        var state : [Any] = [phonenumber, message, selectedDate]
        var state2 : [String : Any] = [phonenumber : (Any).self, message : (Any).self, selectedDate.formatted() : (Any).self]
        
        // Set Async func
        let serialQueue = DispatchQueue(label: "swiftlee.serial.queue")
        serialQueue.async {
            print("[MESSAGE SCHEDULER STARTED] ")
            messageLogic.scheduleiMessage(to: phonenumber, message: message, sendDate: selectedDate)
            print("[MESSAGE SCHEDULER ENDED] ")

        }
        serialQueue.async {
            print("SENDING INFO TO DEVICE STARTED")
            watchConnector.sendIphoneToWatch(info: state2)
            print("SENDING INFO TO DEVICE ENDED")

            
        }
    }
    var body: some View {
        ZStack
        {
            DatePicker(
                           "Select Date and Time",
                           selection: $selectedDate,
                           displayedComponents: [.date, .hourAndMinute]
                       )
                       .datePickerStyle(GraphicalDatePickerStyle())
                       .frame(maxHeight: 400)
                       .padding()
            
        }
        
        
        VStack {
            TextField("phune number", text: $message)
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                          .padding()

                      TextField("message", text: $phonenumber)
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                          .padding()

            
            Button(action: {
                let state = /*T.checkThermalState*/()
                sendData()
            }
            )
            
            {
                
                Text("send date")
            }
            Spacer()
            
            Text("Date received \(watchConnector.parsedReturnData00)"  )
            
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
