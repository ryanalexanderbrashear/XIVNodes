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
    
    var nodePopTimes = ["19:00", "20:00", "21:00"]
    
    var currentEorzeaHour: Int!
    var currentEorzeaMinutes: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: <#T##[String]#>)
        
        Clock.sharedInstance.timeLabel = timeLabel
        
        Clock.sharedInstance.parentVC = self
        
        Clock.sharedInstance.calculateEorzeaTime()
        for nodePopTime in nodePopTimes {
            Clock.sharedInstance.calculateNodePopTime(popTime: nodePopTime)
        }
        Clock.sharedInstance.start()
    }
}

