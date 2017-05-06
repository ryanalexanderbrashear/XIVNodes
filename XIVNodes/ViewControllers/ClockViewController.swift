//
//  ClockViewController.swift
//  XIVNodes
//
//  Created by Ryan Brashear on 4/28/17.
//  Copyright © 2017 Ryan Brashear. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class ClockViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    //var nodePopTimes = ["11:00", "12:00", "03:00", "19:00", "20:00", "21:00", "23:00", "02:00", "16:00", "00:00", "01:00"]
    
    var node: Node!
    
    var currentEorzeaHour: Int!
    var currentEorzeaMinutes: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        node = Node(id: 1, spawnTimes: ["03:00", "05:00", "07:00", "12:00", "13:00", "22:00"])
        
        Clock.sharedInstance.timeLabel = timeLabel
        Clock.sharedInstance.parentVC = self
        Clock.sharedInstance.start()
        
        Clock.sharedInstance.calculateEorzeaTime()
    }
}

