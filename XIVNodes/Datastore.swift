//
//  Datastore.swift
//  XIVNodes
//
//  Created by Ryan Brashear on 5/6/17.
//  Copyright © 2017 Ryan Brashear. All rights reserved.
//

import Foundation

class Datastore {
    
    ////////////////////////////////////////////////////////////////
    static let sharedInstance = Datastore()
    ////////////////////////////////////////////////////////////////
    
    var nodes: [Node] = []
}
