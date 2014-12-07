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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
        var url = "\(Constants.URL_DOCTORS_INSERT)patient_id='\(patientId)'&doctorName='\(nameStr)'&doctorPhoneNumber='\(phoneNumberStr)'&doctorAddress='\(addressStr)'";
        println("dirty url:" + url);
        url = StringHelper.cleanURLString(url)
        println("clean url:" + url);
        HTTPHelper.makeHTTPRequest(url)
    }
}

