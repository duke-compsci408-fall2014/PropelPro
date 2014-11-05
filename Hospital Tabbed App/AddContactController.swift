//
//  AddContactController.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/5/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import UIKit

class AddContactController : UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
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
        println(nameStr)
        println(phoneNumberStr)
        
        var url = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/notifications/insert.php?patient_id='\(patientId)'&recipientName='\(nameStr)'&recipientPhoneNumber='\(phoneNumberStr)'";
        println("dirty url:" + url);
        url = StringHelper.cleanURLString(url)
        println("clean url:" + url);
        makeHTTPRequest(url)
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

