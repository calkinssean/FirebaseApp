//
//  ViewController.swift
//  matchbox20FanClub
//
//  Created by Sean Calkins on 3/24/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

   // var usersArray = [User]()
    
    var eventsArray = [Event]()
    
    var timeSlotArray = [TimeSlot]()
    
    var userRef = Firebase(url: "https://matchbox20fanclub.firebaseio.com/users")
    var eventRef = Firebase(url: "https://matchbox20fanclub.firebaseio.com/events")
    var timeSlotRef = Firebase(url: "https://matchbox20fanclub.firebaseio.com/timeslot")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUsers()
        observeEvents()
        observeTimeSlots()
        // seedTimeSlot()
        // seedUser()
        // seedEvent()
    }
    
    func seedTimeSlot() {
        
        let t = TimeSlot()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM/dd/yyyy"
        if let created = formatter.dateFromString("Apr/20/1969") {
            t.startDate = created
        }
        if let endDate = formatter.dateFromString("Jul/18/2016") {
            t.endDate = endDate
        }
        
        t.name = "9:15"
        t.saveTimeslot()
        
    }

//    func seedUser() {
//        
//        let u = User()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "MMM/dd/yyyy"
//        if let created = formatter.dateFromString("Dec/21/1969") {
//            u.created = created
//        }
//        
//        u.email = "coolguy@email.com"
//        u.password = "coolGuyPassword"
//        u.save()
//       
//    }
    
    func seedEvent() {
        
        let e = Event()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM/dd/yyyy"
        if let created = formatter.dateFromString("Apr/20/1969") {
            e.startDate = created
        }
        if let endDate = formatter.dateFromString("Jul/18/2016") {
            e.endDate = endDate
        }
        e.name = "Coachella"
        e.genre = "Trip Hop"
        e.save()
        
    }
    
    
    func observeUsers() {
        
        // Add observer for Events
        
        self.timeSlotRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
           // self.usersArray.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let dict = snap.value as? [String: AnyObject] {
                        
                        let key = snap.key
                        
                        let timeSlot = TimeSlot(key: key, dict: dict)
                        
                        self.timeSlotArray.insert(timeSlot, atIndex: 0)
                        print(self.timeSlotArray.count)
                    }
                }
            }
        })
    }
    
    func observeTimeSlots() {
        
        // Add observer for Events
        
        self.userRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            //self.usersArray.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let dict = snap.value as? [String: AnyObject] {
                        
                        let key = snap.key
                        
                        //let user = User(key: key, dict: dict)
                        
                        // Add the event to our eventsArray
                        
                        //self.usersArray.insert(user, atIndex: 0)
                       // print(self.usersArray.count)
                    }
                }
            }
        })
    }

    func observeEvents() {
        
        // Add observer for Events
        
        self.eventRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            self.eventsArray.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let dict = snap.value as? [String: AnyObject] {
                        
                        let key = snap.key
                        
                        let event = Event(key: key, dict: dict)
                        
                        // Add the event to our eventsArray
                        self.eventsArray.insert(event, atIndex: 0)
                        print(self.eventsArray.count)
                    }
                }
            }
        })
    }


}

