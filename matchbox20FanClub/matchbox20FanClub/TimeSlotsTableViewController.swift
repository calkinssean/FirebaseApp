//
//  TimeSlotsTableViewController.swift
//  matchbox20FanClub
//
//  Created by Sean Calkins on 3/25/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import Firebase

class TimeSlotsTableViewController: UITableViewController {
    
    var formatter = NSDateFormatter()
    var timeInterval: NSTimeInterval = 0
    var currentEvent = Event()
    var arrayOfTimeSlots = [TimeSlot]()
    var currentEventRef = Firebase(url: "https://matchbox20fanclub.firebaseio.com/events/")
    var timeSlotRef = Firebase(url: "https://matchbox20fanclub.firebaseio.com/timeslot/")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTimeSlots()
        print(currentEvent.hasSeededTimeSlots)
        self.title = "\(currentEvent.name)"
        timeInterval = currentEvent.startDate.timeIntervalSince1970
        currentEventRef = Firebase(url: "https://matchbox20fanclub.firebaseio.com/events/\(currentEvent.key)")
        
        formatter.dateFormat = "MMM/dd/yyyy hh:mm"
        
        self.seedTimeSlots()
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let timeSlot = arrayOfTimeSlots[indexPath.row]
        
        timeSlot.ref?.updateChildValues([
             "taken": !timeSlot.taken
            ])
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfTimeSlots.count
    }
    
    // MARK: - Setting up cell
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SlotCell", forIndexPath: indexPath) as! SlotTableViewCell
        let t = arrayOfTimeSlots[indexPath.row]
        cell.slotNameLabel.text = t.name
        if !t.taken {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.backgroundColor = UIColor.greenColor()
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.backgroundColor = UIColor.redColor()
            cell.textLabel?.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }
    
    func seedTimeSlots() {
        
        if self.currentEvent.hasSeededTimeSlots == false {
            
            if timeInterval < currentEvent.endDate.timeIntervalSince1970 {
                
                let time = NSDate(timeIntervalSince1970: timeInterval)
                let date = formatter.stringFromDate(time)
                print("This is the date: \(date)")
                timeInterval = timeInterval + 900
                let slot = TimeSlot()
                slot.name = date
                slot.eventKey = self.currentEvent.key
                slot.saveTimeslot()
                seedTimeSlots()
                
            } else {
                
                currentEventRef.updateChildValues(["hasSeededTimeSlots": true])
            }
        }
        
    }
    func observeTimeSlots() {
        
        // Add observer for Events
        
        self.timeSlotRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            self.arrayOfTimeSlots.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let dict = snap.value as? [String: AnyObject] {
                        
                        let key = snap.key
                        
                        let slot = TimeSlot(key: key, dict: dict)
                        
                        if slot.eventKey == self.currentEvent.key {
                            
                            slot.ref = Firebase(url: "https://matchbox20fanclub.firebaseio.com/timeslot/\(key)")
                            
                            self.arrayOfTimeSlots.append(slot)
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }
        })
    }
    
    
    
}
