//
//  WatchDataSender.swift
//  AutoTexter Watch App
//
//  Created by Adel Al-Aali on 4/7/24.
//

//
//  WatchDataReceiver.swift
//  ThermoIO Watch App
//
//  Created by Adel Al-Aali on 4/7/24.
//

import Foundation
import WatchConnectivity
import UIKit

class WatchDataReceiver: NSObject, WCSessionDelegate, ObservableObject{

    @Published var parsedReturnData = [String : Any]()
    
    var session: WCSession?

    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    func sendWatchToIphone(info: [String : Any]) {
        print("[!] (FUNCTION) SENDING DATA TO WATCH")
        print("[MESSAGE] \(info)")
                    
        let data : [String : Any ] = [
            "1" : info
            
        ]
        print("[DATA] BEING SENT", data )
        if ((session?.isReachable) != nil) {
            session?.sendMessage(data, replyHandler: nil)
            
        }
    }
   
//
//    func sessionDidBecomeInactive(_ session: WCSession) {
//
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//        <#code#>
//    }
    // WCSessionDelegate methods
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle received message
        print("[DID RECV MESSAGE \(message)" )
        var parsed = message
        parsedReturnData = parsed
        print("[!] parsed return data ")
        if let temperature = message["temperature"] as? Double {
            print("Received temperature: \(temperature)")
            
        }
    }
    

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation completion
        
        print("ACTIVATION STATE" , activationState)
        print("SESSION STATE", session.isReachable)
    }

//    func sessionDidBecomeInactive(_ session: WCSession) {
//        // Handle session becoming inactive
//        print(session.activationState)
//        print(session.description)
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//        // Handle session deactivation
//    }
}
