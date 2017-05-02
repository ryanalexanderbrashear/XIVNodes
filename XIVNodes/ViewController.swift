//
//  ViewController.swift
//  XIVNodes
//
//  Created by Ryan Brashear on 4/28/17.
//  Copyright © 2017 Ryan Brashear. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var nodePopTime = "00:00"
    
    var timer: Timer!
    var eorzeaTimeDisplayFormatter = DateFormatter()
    
    var currentEorzeaHour: Int!
    var currentEorzeaMinutes: Int!
    var currentEorzeaDay: Int!
    var currentEorzeaEpochTime: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        eorzeaTimeDisplayFormatter.dateFormat = "hh:mm a"
        eorzeaTimeDisplayFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        calculateEorzeaTime()
        calculateNodeEarthPopTime(popTime: nodePopTime)
        timer = Timer.scheduledTimer(timeInterval: (35/12), target: self, selector: #selector(calculateEorzeaTime), userInfo: nil, repeats: true)
    }
    
    func calculateEorzeaTime() {
        
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
        currentEorzeaMinutes = comp.minute
        currentEorzeaHour = comp.hour
        
        timeLabel.text = "\(currentEorzeaTime)"
    }
    
    //Takes an Eorzean time in 24 hour format (as a String) and converts it into a time interval used to schedule notifications
    func calculateNodeEarthPopTime(popTime: String) {
        
        //Difference between pop time and current Eorzea time
        var hourDifference = 0
        var minuteDifference = 0
        
        //Take the pop time string and break it into parts
        let time = popTime.components(separatedBy: ":")
        let popHour = Int(time[0])
        let popMinutes = Int(time[1])
        
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
        notification.title = "Test"
        notification.subtitle = ""
        notification.categoryIdentifier = "Alert"
        notification.sound = UNNotificationSound.default()
        notification.body = "Have you completed your task?"
        let notificationDate = Date().addingTimeInterval(timeInterval)
        let notificationTime = notificationDate.timeIntervalSinceNow
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTime, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request)
    }
}

extension ViewController:UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
}

