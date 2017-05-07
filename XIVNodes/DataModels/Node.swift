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
    var numberOfSpawnsPerDay: Int!
    var previousSpawnTimes: [String] = []
    var timeUntilNextSpawn: TimeInterval! {
        didSet {
            //When timeUntilNextSpawn is set, send a notification that will signal that a local notification needs to be createds
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scheduleNodeNotification"), object: self, userInfo: ["nodeID" : id, "spawnInterval" : timeUntilNextSpawn])
            if spawnTimes.count > 1 {
                //If the node has more than one spawn time a day, move the most recent spawn time to the previous spawn times array so we don't get duplicate notifications
                previousSpawnTimes.append(spawnTimes.remove(at: 0))
                timer = Timer.scheduledTimer(timeInterval: timeUntilNextSpawn, target: self, selector: #selector(getNextSpawn), userInfo: nil, repeats: false)
            } else {
                //Otherwise, if the values left in the spawn times array are equal to 1
                if numberOfSpawnsPerDay > 1 {
                    //If the node has more than one spawn time a day, reset the spawn times array by taking all the values from the previous spawn times array and resetting it to empty, then set the timer for the next spawn time
                    previousSpawnTimes.append(spawnTimes.remove(at: 0))
                    spawnTimes = previousSpawnTimes
                    previousSpawnTimes = []
                    timer = Timer.scheduledTimer(timeInterval: timeUntilNextSpawn, target: self, selector: #selector(getNextSpawn), userInfo: nil, repeats: false)
                } else {
                    //If the node only spawns once per day, set the timer to fire one Eorzean day from the pop time
                    timer = Timer.scheduledTimer(timeInterval: timeUntilNextSpawn + 4200, target: self, selector: #selector(getNextSpawn), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    var timer: Timer!
    
    init(id: Int, spawnTimes: [String]) {
        self.id = id
        self.spawnTimes = spawnTimes
        self.numberOfSpawnsPerDay = spawnTimes.count
    }
    
    @objc func getNextSpawn() {
        
        //The current Eorzea time converted to a Float
        let currentEorzeaTime = Float(Clock.sharedInstance.currentEorzeaHour) + Float(Clock.sharedInstance.currentEorzeaMinutes/100)
        
        spawnTimes.sort { (s1, s2) -> Bool in
            //Convert the two spawn times into Floats
            let firstSpawnTime = convertTimeToNumber(timeString: s1)
            let secondSpawnTime = convertTimeToNumber(timeString: s2)
            
            //The time until the spawn relative to the current Eorzea time
            var timeUntilFirstSpawn = firstSpawnTime - currentEorzeaTime
            var timeUntilSecondSpawn = secondSpawnTime - currentEorzeaTime
            
            //If the time is negative, we know this spawn is going to be happening on the next day since the pop time in 24 hour time is less than the current time, so add 24 hours to the time until spawn
            if timeUntilFirstSpawn <= 0 {
                timeUntilFirstSpawn.add(24.0)
            }
            
            if timeUntilSecondSpawn <= 0 {
                timeUntilSecondSpawn.add(24.0)
            }
            
            //Return the comparison of the adjusted times until spawn so that the spawn times are sorted in temporal order
            return timeUntilFirstSpawn < timeUntilSecondSpawn
        }
        timeUntilNextSpawn = Clock.sharedInstance.calculateNodePopTime(popTime: spawnTimes[0])
    }
}
