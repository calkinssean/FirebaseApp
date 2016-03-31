//
//  CalendarViewController.swift
//  matchbox20FanClub
//
//  Created by Sean Calkins on 3/25/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController {
    
    
    //MARK: - Properties
    let eventStore = EKEventStore()
    
    var hasAccessToEventStore: Bool?
    
    var arrayOfEvents = [Event]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
    }
    
    
    //Checking for access to event store
    func checkForAuth() {
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
            })
        } else {
            
        }
    }
    
    
    
}
