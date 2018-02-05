//
//  LocalDatasource.swift
//  It's On!
//
//  Created by Eduardo Pérez on 05/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import EventKit
import Foundation

class LocalDataSource {
    let prefix_name = "ITSON_"
    static let sharedInstance = LocalDataSource()
    
    static func getInstance() -> LocalDataSource {
        return sharedInstance
    }
    
    func isFirstLaunch() -> Bool {
        return (UserDefaults.standard.value(forKey: "username")) == nil;
    }
    
    func getDeviceId() -> String {
        return "Iphone"
    }
    
    func getFCMToken() -> String {
        return "wehqwgegqybgyubuybacygubgyugubycas"
    }
    
    /** Store Session data **/
    func storeCoconut(token: String,for coconut:String,with message:String,set notifications:Bool,and reminders:Bool) -> Bool {
        
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(coconut, forKey: "username")
        UserDefaults.standard.set(message, forKey: "message")
        UserDefaults.standard.set(notifications, forKey: "notification")
        UserDefaults.standard.set(reminders, forKey: "reminders")
        UserDefaults.standard.set("", forKey: "avater")
        
        AppConfigs.RUNTIME_TOKEN = token
    
        return true
    }
    
    func storePassword(pass: String) {
        UserDefaults.standard.set(pass, forKey: "password")
    }
    
    func getPassword() -> String {
        return UserDefaults.standard.string(forKey: "password")!
    }
    
    func getCoconut() -> NutAuth {
        let nut = NutAuth()
        
        //TODO
        return nut
    }
    
    /** Retrieves Coconut Gamertag object **/
    func getCoconutTag() -> String {
        return UserDefaults.standard.value(forKey: "username") as! String;
    }
    
    /** Retrieves coconut key **/
    func getCoconutKey() {
        AppConfigs.RUNTIME_TOKEN = UserDefaults.standard.value(forKey: "token") as! String;
      //  return UserDefaults.standard.value(forKey: "token") as! String
    }
    
    /** Store coconut key **/
    func storeCoconutKey(for token: String) -> Bool {
        UserDefaults.standard.set(token, forKey: "token")
        AppConfigs.RUNTIME_TOKEN = token
        return true
    }
    
    /** Retrieves coconut Avatar **/
    func getCoconutAvatar() -> String {
        return UserDefaults.standard.value(forKey: "avatar") as! String
    }
    
    /** Store coconut Avatar **/
    func storeCoconutAvatar(for image: String) -> Bool {
        UserDefaults.standard.set(image, forKey: "avatar")
        return true
    }
    
    /** Retrieves coconut Notificatin preference **/
    func getNotificationPreferences() -> Bool {
        return UserDefaults.standard.bool(forKey: "notification")
    }
    
    /** Retrieves coconut Reminders preference **/
    func getRemindersPreferences() -> Bool {
        return UserDefaults.standard.bool(forKey: "reminders")
    }
    
    /** Store coconut preferences **/
    func storeCoconutPreferences(for notifications: Bool,and reminders: Bool) -> Bool {
        UserDefaults.standard.set(notifications, forKey: "notification")
        UserDefaults.standard.set(reminders, forKey: "reminders")
        return true
    }
    
    /** Retrieves Status. Keep Track for nil **/
    func getStatus() -> String {
        let message = UserDefaults.standard.value(forKey: "message") as! String
        return message
    }
    
    /** Store status **/
    func storeStatus(for message: String) {
        UserDefaults.standard.set(message, forKey: "message")
    }
    
    /** Store Event Data **/
    func store(fruit: Fruit) -> Bool {
        let eventStore = EKEventStore()
        
        let eventData = fruit.fruit as! Dictionary<String, Any>
        let gameTitle = eventData["game_title"] as! String
        let platform = eventData["platform"] as! String
        let seconds = Double(eventData["date_promise"] as! String)!/1000.00
        
        var demolition: Int = 0
        let startDate = Date(timeIntervalSince1970: seconds)
        var finishDate =  Date(timeIntervalSince1970: seconds)
        
        let reminders = fruit.reminders
        print(reminders.count)
        
        if (reminders.count == 1) {
            let reminder = reminders[0]
            
            print("Number=>%d",reminder.reminder)
            demolition = reminder.reminder
        }
        
        finishDate.addTimeInterval( TimeInterval(1*60*60) )
        
        eventStore.requestAccess(to: EKEntityType.event, completion: {(granted, error) in
            if granted && (error == nil) {
                print("Permiso confirmado")
                
                let event = EKEvent(eventStore: eventStore)
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.title = eventData["title"] as! String
                event.notes =  gameTitle+" On "+platform
                event.startDate = startDate
                event.endDate = finishDate
                event.addAlarm( EKAlarm.init(
                    relativeOffset: self.obtainTimeAlarmOffset(demolition: demolition)) )
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let specError as NSError {
                    print("An error occurred: \(specError)")
                }catch {
                    print("An errpr occurred")
                }
                print("Event saved")
                
            } else {
                print("No permission granted")
            }
        })
        
        return true
    }
    
    /** Store Event Data **/
    func store(fruit: String,game title:String,on platform: String,date: String,and demolition:Int ) -> Bool {
        let eventStore = EKEventStore()
        let seconds = Double(date)!/1000.00
        
        let startDate = Date(timeIntervalSince1970: seconds)
        var finishDate =  Date(timeIntervalSince1970: seconds)
        
        finishDate.addTimeInterval( TimeInterval(1*60*60) )
        
        eventStore.requestAccess(to: EKEntityType.event, completion: {(granted, error) in
            if granted && (error == nil) {
                print("Permiso confirmado")
                
                let event = EKEvent(eventStore: eventStore)
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.title = fruit
                event.notes =  title+" On "+platform
                event.startDate = startDate
                event.endDate = finishDate
                event.addAlarm( EKAlarm.init(
                    relativeOffset: self.obtainTimeAlarmOffset(demolition: demolition)) )
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let specError as NSError {
                    print("An error occurred: \(specError)")
                }catch {
                    print("An errpr occurred")
                }
                print("Event saved")
                
            } else {
                print("No permission granted")
            }
        })
        
        return true
    }
    
    /** Remove Stored Coconut **/
    func removeStoredCoconut() -> Bool {
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.set(nil, forKey: "username")
        UserDefaults.standard.set("", forKey: "message")
        UserDefaults.standard.set(false, forKey: "notification")
        UserDefaults.standard.set(false, forKey: "reminders")
        UserDefaults.standard.set("", forKey: "avater")
        UserDefaults.standard.set(nil, forKey: "password")
        
        return true
    }
    
    /** Remove Stored Events **/
    func removeStored(fruit: Fruit) -> Bool{
        return true
    }
    
    internal func obtainTimeAlarmOffset(demolition: Int) -> TimeInterval {
        var timer = TimeInterval(0*60*60)
        
        switch demolition { //H*M*S(CONST)
        case 1:
            timer = TimeInterval(1*5*60)
            break
        case 2:
            timer = TimeInterval(1*15*60)
            break
        case 3:
            timer = TimeInterval(1*30*60)
            break
        case 4:
            timer = TimeInterval(1*60*60)
            break;
        case 5:
            timer = TimeInterval(2*60*60)
            break
        default:
            timer = TimeInterval(0*60*60)
            break
        }
        
        return timer
    }
    
    
}
