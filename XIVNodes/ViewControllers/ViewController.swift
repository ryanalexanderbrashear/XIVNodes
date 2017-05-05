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
    
    var nodePopTimes = ["11:00", "12:00", "03:00", "19:00", "20:00", "21:00", "23:00", "02:00", "16:00"]
    
    var currentEorzeaHour: Int!
    var currentEorzeaMinutes: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        Clock.sharedInstance.timeLabel = timeLabel
        
        Clock.sharedInstance.parentVC = self
        
        Clock.sharedInstance.calculateEorzeaTime()
        for nodePopTime in nodePopTimes {
            Clock.sharedInstance.calculateNodePopTime(popTime: nodePopTime)
        }
        Clock.sharedInstance.start()
    }
}

