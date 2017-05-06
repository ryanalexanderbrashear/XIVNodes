//
//  Utilities.swift
//  XIVNodes
//
//  Created by Ryan Brashear on 5/6/17.
//  Copyright © 2017 Ryan Brashear. All rights reserved.
//

import Foundation

public func convertTimeToNumber(timeString: String) -> Float {
    let time = timeString.components(separatedBy: ":")
    let hour = Float(time[0])
    let minutes = Float(time[1])
    
    return hour! + (minutes!/100)
}
