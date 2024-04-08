

import Foundation
//
//  ScheduleMessageLogic.swift
//  AutoTexter
//
//  Created by Adel Al-Aali on 4/7/24.
//

import Foundation
import EventKit


class ScheduleMessageLogicW : ObservableObject {
    
    func scheduleiMessage(to phoneNumber: String, message: String, sendDate: Date) {
        
        do {
            
            
            print("[!] SCHEDULING MESSAGE FROM WATCH ")
            let eventStore = EKEventStore()
            
            eventStore.requestFullAccessToReminders { granted, error in
                // Handle the response to the request.
                if (error != nil) {
                    print("REQUESTING FULL ACCESS" , error)
                }
            }
            let event = EKEvent(eventStore: eventStore)
            
            event.title = "Scheduled iMessage"
            event.notes = message
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            // Set the start date for the event (specific time)
            event.startDate = sendDate
            event.endDate = sendDate.addingTimeInterval(60) // 1 minute duration
            
            // Create an alarm to trigger the event
            let alarm = EKAlarm(relativeOffset: 0)
            event.addAlarm(alarm)
        
    } catch {
        print("Error scheduling iMessage: \(error.localizedDescription)")
    }
        do {
            //try eventStore.save(event, span: .thisEvent)
            
            print("DEBUG HERE ")
            print("iMessage scheduled successfully for \(sendDate).")
        } catch {
            print("Error scheduling iMessage: \(error.localizedDescription)")
        }
    }
}
//// Usage example:
//let phoneNumber = "1235551234" // Replace with the recipient's phone number
//let message = "Hello there!" // Replace with your desired message
//let sendDate = Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date())! // Set the desired time


//scheduleiMessage(to: phoneNumber, message: message, sendDate: sendDate)
