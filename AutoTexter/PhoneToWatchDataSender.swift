//
//  PhoneToWatchDataSender.swift
//  AutoTexter
//
//  Created by Adel Al-Aali on 4/7/24.
//


import Foundation

import WatchConnectivity

class PhoneToWatchDataSender: NSObject, WCSessionDelegate , ObservableObject{
    
    var session: WCSession?

    @Published var parsedReturnData00 = [String : Any]()


    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sendIphoneToWatch(info: [String : Any]) {
        print("[!] SENDING DATA TO WATCH")
        print("[MESSAGE] \(info)")
        if ((session?.isReachable) != nil) {
            session?.sendMessage(info, replyHandler: nil)
            print("[!] Messag sent")
        }
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }

    func sendTemperatureDataToWatch(temperatureData: [String: Any]) {
        if let validSession = session, validSession.isReachable {
            validSession.sendMessage(temperatureData, replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
        }
    }

    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle received message
        print("[DID RECV MESSAGE \(message)" )
        var parsed = message
        parsedReturnData00 = parsed
        print("[!] parsed return data ")
        print(parsedReturnData00)
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
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//        // Handle session deactivation
//    }
}
