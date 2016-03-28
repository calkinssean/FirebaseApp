//
//  EventsTableViewController.swift
//  matchbox20FanClub
//
//  Created by Sean Calkins on 3/25/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import Firebase

class EventsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let ref = Firebase(url: "https://matchbox20fanclub.firebaseio.com/events")
    
    var authId = ""
    
    var currentEvent = Event()
    
    var arrayOfEvents = [Event]()
    
    var formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"
        observeEvents()
        formatter.dateFormat = "MMM/dd/yyyy hh:mm"
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
    }
    
    @IBAction func addTapped(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create Event",
            message: "Create Event",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction) -> Void in
                
                let nameField = alert.textFields![0]
                let genreField = alert.textFields![1]
                let startDateField = alert.textFields![2]
                let endDateField = alert.textFields![3]
                
                let e = Event()
                
                if let created = self.formatter.dateFromString("\(startDateField.text!)") {
                    e.startDate = created
                }
                
                if let endDate = self.formatter.dateFromString("\(endDateField.text!)") {
                    e.endDate = endDate
                }
                
                e.name = "\(nameField.text!)"
                e.genre = "\(genreField.text!)"
                e.userKey = self.authId
                
                e.save()
                
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (nameField) -> Void in
            nameField.placeholder = "Name of Event"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (genreField) -> Void in
            genreField.placeholder = "Genre of Event"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (startDateField) -> Void in
            startDateField.placeholder = "Start Date: Dec/25/2016 08:00"
        }
        alert.addTextFieldWithConfigurationHandler {
            (endDateField) -> Void in
            endDateField.placeholder = "End Date: Dec/25/2016 11:00"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfEvents.count
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.currentEvent = arrayOfEvents[indexPath.row]
        performSegueWithIdentifier("showTimeSlotsSegue", sender: self)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let e = arrayOfEvents[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as? CustomTableViewCell {
            
            cell.nameLabel.text = e.name
            cell.genreLabel.text = e.genre
            cell.startDateLabel.text = formatter.stringFromDate(e.startDate)
            cell.endDateLabel.text = formatter.stringFromDate(e.endDate)
            
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Event Observer
    
    func observeEvents() {
        
        // Add observer for Events
        
        self.ref.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            self.arrayOfEvents.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let dict = snap.value as? [String: AnyObject] {
                        
                        let key = snap.key
                        print(key)
                        let event = Event(key: key, dict: dict)
                        event.ref = Firebase(url: "https://matchbox20fanclub.firebaseio.com/events/\(key)")
                        // Add the event to our eventsArray
                        self.arrayOfEvents.insert(event, atIndex: 0)
                        print(self.arrayOfEvents.count)
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTimeSlotsSegue" {
            
            let controller = segue.destinationViewController as! TimeSlotsTableViewController
            controller.currentEvent = self.currentEvent
            
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let event = arrayOfEvents[indexPath.row]
            event.ref?.removeValue()
            
        } else if editingStyle == .Insert {
            
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
