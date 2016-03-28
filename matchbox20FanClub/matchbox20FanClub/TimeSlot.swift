//
//  Time Slot.swift
//  matchbox20FanClub
//
//  Created by Sean Calkins on 3/24/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import Foundation
import Firebase

class TimeSlot {
    
    var key: String = ""
    var userKey: String = ""
    var eventKey: String = ""
    var name: String = ""
    var startDate = NSDate()
    var endDate = NSDate()
    var ref: Firebase?
    var taken: Bool = false
    
    var eventRef = Firebase(url: "https://matchbox20fanclub.firebaseio.com/timeslot")
    
    init() {
        
    }
    
    init(key: String, dict: [String: AnyObject]) {
        
        self.key = key
        
        if let eventKey = dict["eventKey"] as? String {
            self.eventKey = eventKey
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
        if let startDateInterval = dict["startDate"] as? NSTimeInterval {
            self.startDate = NSDate(timeIntervalSince1970: startDateInterval)
        }
        if let endDateInterval = dict["endDate"] as? NSTimeInterval {
            self.endDate = NSDate(timeIntervalSince1970: endDateInterval)
        }
        if let taken = dict["taken"] as? Bool {
            self.taken = taken
        }

    }
    
    func saveTimeslot() {
        
        let startDateInterval = self.startDate.timeIntervalSince1970
        let endDateInterval = self.endDate.timeIntervalSince1970
        
        
        let dict = [
            "name": self.name,
            "startDate": startDateInterval,
            "endDate": endDateInterval,
            "userKey": self.userKey,
            "taken": self.taken,
            "eventKey": self.eventKey
            
        ]
        
        let firebaseEvent = self.eventRef.childByAutoId()
        firebaseEvent.setValue(dict)
        
    }
}