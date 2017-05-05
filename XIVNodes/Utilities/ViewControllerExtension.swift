//
//  ViewControllerExtension.swift
//  XIVNodes
//
//  Created by Ryan Brashear on 5/2/17.
//  Copyright © 2017 Ryan Brashear. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI

extension ViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("hello")
        completionHandler([.alert,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Determine the user action
        switch response.actionIdentifier {
        default:
            print("Stuff")
        }
        completionHandler()
    }
}
