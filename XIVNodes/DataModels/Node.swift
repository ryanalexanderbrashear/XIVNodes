//
//  Node.swift
//  XIVNodes
//
//  Created by Ryan Brashear on 5/3/17.
//  Copyright © 2017 Ryan Brashear. All rights reserved.
//

import Foundation

class Node {
    /* Stores information about gathering nodes.
     * Zone
     * Spawn Times
     * Contents
     * Slot
     * Item Name
     * Class that can gather it
     */
    
    var id: Int!
    var spawnTimes: [String]!
    
    init(id: Int, spawnTimes: [String]) {
        self.id = id
        self.spawnTimes = spawnTimes
    }
    
    func getNextSpawn() -> String {
        let currentEorzeaTime = Float(Clock.sharedInstance.currentEorzeaHour) + Float(Clock.sharedInstance.currentEorzeaMinutes/100)
        spawnTimes.sort { (s1, s2) -> Bool in
            var time1 = convertTimeToNumber(timeString: s1)
            var time2 = convertTimeToNumber(timeString: s2)
            
            if time1 - currentEorzeaTime <= 0 {
                time1.add(24.0)
            }
            
            if time2 - currentEorzeaTime <= 0 {
                time2.add(24.0)
            }
            return (time1 - currentEorzeaTime) < (time2 - currentEorzeaTime)
        }
        return spawnTimes[0]
    }
}
