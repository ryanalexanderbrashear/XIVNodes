//
//  Clock.swift
//  XIVNodes
//
//  Created by Ryan Brashear on 5/2/17.
//  Copyright © 2017 Ryan Brashear. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI

class Clock {
    
    static let sharedInstance = Clock()
    
    //Label that will display the current Eorzea time
    var timeLabel: UILabel!
    
    //View controller that the clock is being displayed in
    var parentVC: ViewController!
    
    //Timer used to update the current Eorzea time
    var timer: Timer!
    
    var eorzeaTimeDisplayFormatter = DateFormatter()
    
    var currentEorzeaHour: Int!
    var currentEorzeaMinutes: Int!
    
    func start() {
        eorzeaTimeDisplayFormatter.dateFormat = "hh:mm a"
        eorzeaTimeDisplayFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        timer = Timer.scheduledTimer(timeInterval: (35/12), target: self, selector: #selector(calculateEorzeaTime), userInfo: nil, repeats: true)
    }
    
    @objc func calculateEorzeaTime() {
        //Get current epoch time
        let epochTime = Date().timeIntervalSince1970
        
        //Get the Eorzean epoch time
        let eorzeaEpoch = epochTime * (3600/175)
        
        //Create a date from the Eorzean epoch time
        let eorzeaDate = Date(timeIntervalSince1970: eorzeaEpoch)
        
        //Format the date and display it in the time label
        let currentEorzeaTime = eorzeaTimeDisplayFormatter.string(from: eorzeaDate)
        
        //Get the current hour and minute in Eorzean time
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let comp = calendar.dateComponents([.hour, .minute], from: eorzeaDate)
        currentEorzeaMinutes = comp.minute!
        currentEorzeaHour = comp.hour!
        
        timeLabel.text = currentEorzeaTime
    }
    
    //Takes an Eorzean time in 24 hour format (as a String) and converts it into a time interval used to schedule notifications
    func calculateNodePopTime(popTime: String) {
        //Difference between pop time and current Eorzea time
        var hourDifference = 0
        var minuteDifference = 0

        //Take the pop time string and break it into parts
        let time = popTime.components(separatedBy: ":")
        let popHour = Int(time[0])

        //If we aren't at an exact hour, get the minutes until the next hour
        if currentEorzeaMinutes != 0 {
            minuteDifference = 60 - currentEorzeaMinutes!
        }

        if popHour! > currentEorzeaHour {
            hourDifference = popHour! - currentEorzeaHour
        } else {
            hourDifference = 24 - (currentEorzeaHour - popHour!)
        }

        //Since we aren't exactly at a specific hour, we know the hours until the pop will be offset because we are minutes into an hour, so subtract one from the hour difference
        if minuteDifference > 0 && hourDifference > 0 {
            hourDifference -= 1
        }

        //Get the number of seconds for the hours until the pop (175 seconds = 1 eorzean hour)
        let hourTimeInterval = hourDifference * 175

        //Get the number of seconds for the minutes until the pop (35/12 seconds = 1 eorzean minute)
        let minuteTimeInterval = Double(minuteDifference) * Double((35/12))

        //Create a time interval from the seconds for the hours and minutes
        let notificationTime = TimeInterval(hourTimeInterval + Int(minuteTimeInterval))
        
        //Schedule a notification using that time interval
        scheduleNotification(timeInterval: notificationTime)
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        let notification = UNMutableNotificationContent()
        notification.title = "XIVNode"
        notification.subtitle = ""
        notification.categoryIdentifier = "Alert"
        notification.sound = UNNotificationSound.default()
        notification.body = "Node will pop soon!"
        let notificationDate = Date().addingTimeInterval(timeInterval)
        let notificationTime = notificationDate.timeIntervalSinceNow
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTime, repeats: false)
        
        //TODO: Change the identifier here to something that can easily identify the node (perhaps ID when we get the backend working. Will be used to look up the node and get the next spawn time for scheduling the next notification
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().delegate = parentVC
        UNUserNotificationCenter.current().add(request)
    }
}
