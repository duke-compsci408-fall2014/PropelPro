//
//  AddPhysicianController.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 10/29/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import UIKit

class AddPhysicianController : UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        saveButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
        
    func buttonAction(sender:UIButton!)
    {
        var patientId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        var nameStr : String = nameField.text;
        var phoneNumberStr : String = phoneNumberField.text;
        var addressStr : String = addressField.text;
        println(nameStr)
        println(phoneNumberStr)
        println(addressStr)
        var url = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/doctors/insert.php?patient_id='\(patientId)'&doctorName='\(nameStr)'&doctorPhoneNumber='\(phoneNumberStr)'&doctorAddress='\(addressStr)'";
        println("dirty url:" + url);
        url = cleanURLString(url)
        println("clean url:" + url);
        makeHTTPRequest(url)
    }
    
    // TODO: clean it up to comply with our JSON parsing assumptions
    func cleanURLString(url : String) ->String {
        var out : String = "";
        for char in url {
            if char == " " {
                out += "%20"
            } else {
                out += "\(char)";
            }
        }
        return out
    }

    func makeHTTPRequest(urlStringWithParameters : String) {
        let url = NSURL(string: urlStringWithParameters)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error! \(NSString(data: data, encoding: NSUTF8StringEncoding))")
            } else {
                println("success! \(NSString(data: data, encoding: NSUTF8StringEncoding))")
            }
        }
        task.resume()
    }
    
}

