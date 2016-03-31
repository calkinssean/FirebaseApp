//
//  MenuController.swift
//  matchbox20FanClub
//
//  Created by Sean Calkins on 3/25/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import Firebase

class MenuController: UITableViewController {

    let ref = Firebase(url: "https://matchbox20fanclub.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    //MARK: - Log out button
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            ref.unauth()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

}
