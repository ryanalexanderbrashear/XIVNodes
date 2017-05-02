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
    
    var nodePopTime = "8:59"
    
    var timer: Timer!
    var eorzeaTimeDisplayFormatter = DateFormatter()
    
    var currentEorzeaHour: Int!
    var currentEorzeaMinutes: Int!
    var currentEorzeaDay: Int!
    var currentEorzeaEpochTime: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Get the current hour, minute, and day in Eorzean time
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let comp = calendar.dateComponents([.day, .hour, .minute], from: eorzeaDate)
        currentEorzeaMinutes = comp.minute
        if comp.hour! <= 12 {
            currentEorzeaHour = comp.hour
        } else if comp.hour! == 0 {
            currentEorzeaHour = 12
        } else {
            currentEorzeaHour = comp.hour! - 12
        }
        
        timeLabel.text = "\(currentEorzeaTime)"
    }
    
    func calculateNodeEarthPopTime(popTime: String) {
        
        var hourDifference = 0
        var minuteDifference = 0
        
        let time = popTime.components(separatedBy: ":")
        let popHour = Int(time[0])
        let popMinutes = Int(time[1])
        
        if popHour! >= currentEorzeaHour {
            hourDifference = popHour! - currentEorzeaHour
        } else {
            hourDifference = 24 - (currentEorzeaHour - popHour!)
        }
        
        if popMinutes! > currentEorzeaMinutes {
            minuteDifference = popMinutes! - currentEorzeaMinutes
        }
        
        let notificationTime = 
            TimeInterval((hourDifference * 175) + (minuteDifference * (35/12)))
        
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

