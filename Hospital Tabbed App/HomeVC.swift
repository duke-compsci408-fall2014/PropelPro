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
    
    private struct ClassVars {
        static var name : String = "";
        static func getName() -> String {
            return name
        }
        static func setName(s: String) {
            name = s
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("called viewDidLoad() with name: \(ClassVars.getName())")
        if (ClassVars.getName().isEmpty) {
            fetchName()
        } else {
            self.nameField.hidden = true;
            self.updateNameButton.hidden = true;
            self.welcomeLabel.text = "Welcome, \(ClassVars.getName())!";
            self.welcomeLabel.hidden = false;
        }
        ClassVars.setName("chin")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    func fetchName() {
        println("fetching name")
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        println("device id:\(deviceId)")
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/patients/select.php?attribute=*&patient_id='\(deviceId)'"
        var url = NSURL(string: urlStr)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error")
            } else {
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                if (output.isEmpty || output == "200") {
                    println("patient not found")
                    self.nameField.hidden = false;
                    self.updateNameButton.hidden = false;
                    self.welcomeLabel.hidden = true;
                }
                else {
                    println("patient found")
                    println(output)
                    var patient : JSON = JSONArray(str: output).getObjects()[0]
                    var name : String = patient.getMap()["patientName"]!
                    ClassVars.setName(name)
                    println("Name: \(ClassVars.getName())")
                    self.viewDidLoad()
                }
            }
        }
        task.resume()
    }
    
    @IBAction func updateNameAction(sender: AnyObject) {
        println("Updating name")
        ClassVars.setName(nameField.text)
        println("Name: \(ClassVars.getName())")
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        println("device id:\(deviceId)")
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/patients/insert.php?patient_id='\(deviceId)'&patientName='\(StringHelper.cleanURLString(ClassVars.getName()))'"
        var url = NSURL(string: urlStr)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error")
            } else {
                println("added new name to DB!")
                self.viewDidLoad()
            }
        }
        task.resume()
    }
}