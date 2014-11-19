//
//  HomeVC.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/17/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import UIKit

class HomeVC : UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var updateNameButton: UIButton!
    
    let deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchName()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func fetchName() {
        println("fetching name")
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/patients/select.php?attribute=*&patient_id='\(deviceId)'"
        var url = NSURL(string: urlStr)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error")
            } else {
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                if (output.isEmpty || output == "200") {
                    println("First time using this device.")
                    // Do nothing. Patient will need to update their name on their own
                }
                else {
                    var patient : JSON = JSONArray(str: output).getObjects()[0]
                    var name : String = patient.getMap()["patientName"]!
                    dispatch_async(dispatch_get_main_queue(), {
                        self.welcomeLabel.text = "Welcome, \(name)"
                    });
                }
            }
        }
        task.resume()
    }
    
    @IBAction func updateNameAction(sender: AnyObject) {
        var newName = nameField.text
        dispatch_async(dispatch_get_main_queue(), {
            self.welcomeLabel.text = "Welcome, \(newName)"
            self.nameField.text = ""
        });
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/patients/update.php?patient_id='\(deviceId)'&patientName='\(StringHelper.cleanURLString(newName))'"
        var url = NSURL(string: urlStr)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error")
            } else {
                println("added new name to DB!")
            }
        }
        task.resume()
    }
}