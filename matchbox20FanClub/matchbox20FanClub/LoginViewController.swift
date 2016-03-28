//
//  LoginViewController.swift
//  matchbox20FanClub
//
//  Created by Sean Calkins on 3/25/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import QuartzCore
import Firebase

class LoginViewController: UIViewController {
    
    var authId = ""
    
    let LoggedIn = "LoggedIn"
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Properties
    let ref = Firebase(url: "https://matchbox20fanclub.firebaseio.com")
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                print(authData)
                
                self.authId = authData.uid
                
                self.performSegueWithIdentifier(self.LoggedIn, sender: self)
                
                

            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.textFieldLoginEmail.text = ""
        self.textFieldLoginPassword.text = ""
        
    }
    
    // MARK: Actions
    @IBAction func loginDidTouch(sender: AnyObject) {
        
        ref.authUser(textFieldLoginEmail.text, password: textFieldLoginPassword.text, withCompletionBlock: { (error, auth) -> Void in
            
        })
        
    }
    
    @IBAction func signUpDidTouch(sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
            message: "Register",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction) -> Void in
                
                let emailField = alert.textFields![0]
                let passwordField = alert.textFields![1]
                
                self.ref.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
                    
                    if error == nil {
                        
                        self.ref.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) in
                            
                        })
                    }
                }
                
                
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "\(self.LoggedIn)" {
           // let controller = segue.destinationViewController as! SWRevealViewController
           // controller.authId = self.authId
        }
    }
    
}
