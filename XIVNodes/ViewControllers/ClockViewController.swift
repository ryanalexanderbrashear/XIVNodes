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
    
    var currentEorzeaHour: Int!
    var currentEorzeaMinutes: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        let node = Node(id: 1, spawnTimes: ["03:00"])
        
        Datastore.sharedInstance.nodes.append(node)
        
        Clock.sharedInstance.timeLabel = timeLabel
        Clock.sharedInstance.parentVC = self
        Clock.sharedInstance.start()
        
        Clock.sharedInstance.calculateEorzeaTime()
        
        node.getNextSpawn()
    }
}

