//
//  ContentView.swift
//  AutoTexter
//
//  Created by Adel Al-Aali on 4/7/24.
//

import SwiftUI
import WatchKit


struct ContentView: View {
    @State var thermalState = ""
    @State var date = Date.now
    @State var time = Date.timeIntervalSinceReferenceDate
    @State private var selectedDate = Date()
    @State private var phoneNumber: String = ""

    @State  var phonenumber: String = ""
    @State  var message: String = ""

    @StateObject var messageLogicW = ScheduleMessageLogicW()

    
    // Try this if data flow doesnt work properly
    @StateObject var watchConnector = WatchDataReceiver() // Inits watch data class
    @State private var userInput: String = ""
    
//     func presentTextInputController() {
//           // Present the text input interface
//           let suggestions = ["123-456-7890", "098-765-4321"] // Provide some example formats
//           WKInterfaceController().presentTextInputController(withSuggestions: suggestions, allowedInputMode: .plain) { result in
//               // Handle the result of the text input
//               if let result = result as? [String], !result.isEmpty {
//                   self.phoneNumber = result.first!
//               }
//           }
//       }
    

    func sendData() {
        print("[!] SENDING DATA TO WATCH")
        print("PH \($phonenumber.wrappedValue)",
              "MSG \($message.wrappedValue)",
              "\(selectedDate)")
        
        var state = [phonenumber : 0, message : 1, selectedDate.formatted() : 2]

        
        var state2 : [String : Any] = [phonenumber : (Any).self, message : (Any).self, selectedDate.formatted() : (Any).self]
        
        print(state)
        
        watchConnector.sendWatchToIphone(info: state[phone])
        
        let serialQueue = DispatchQueue(label: "swiftlee.serial.queue")
        serialQueue.async {
            print("[MESSAGE SCHEDULER STARTED] ")
            messageLogicW.scheduleiMessage(to: phonenumber, message: message, sendDate: selectedDate)
            print("[MESSAGE SCHEDULER ENDED] ")
            
        }
        serialQueue.async {
            print("SENDING INFO TO DEVICE STARTED")
            watchConnector.sendWatchToIphone(info: state2)
            print("SENDING INFO TO DEVICE ENDED")
            
            
            
        }
    }
        var body: some View {
            HStack {
                
                TextField("message", text: $message)
                    .frame(maxHeight: 11)
            }
            ZStack
            {
                DatePicker(
                    "Select Date and Time",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                
                .frame(maxHeight: 400)
            }
            
            HStack {
                TextField("phone number", text: $phonenumber)
            }
            
            VStack {
                
                Spacer()
                
                DatePicker(
                    "Select Date and Time",
                    selection: $selectedDate,
                    displayedComponents:.hourMinuteAndSecond
                )
                
                .frame(maxHeight: 400)
                .padding()
                
                Button(action: {
                    let state = selectedDate
                    print("button pressed, sending data")
                    sendData()
                }
                )
                
                {
                    
                    Text("send date")
                }
            }
            
            
        }
    
    
}


#Preview {
    ContentView()
}
