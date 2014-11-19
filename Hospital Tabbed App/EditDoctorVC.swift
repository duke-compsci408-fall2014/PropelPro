//
//  EditDoctorVC.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/19/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import UIKit

class EditDoctorVC : UIViewController {
    var doctorId : String!;
    var doctorName : String!;
    var doctorPhoneNumber : String!;
    var doctorAddress : String!;
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = self.doctorName
        phoneNumberField.text = self.doctorPhoneNumber
        addressField.text = self.doctorAddress
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        var doctorId : String = self.doctorId
        var nameStr : String = nameField.text;
        var phoneNumberStr : String = phoneNumberField.text;
        var addressStr : String = addressField.text;
        println(nameStr)
        println(phoneNumberStr)
        println(addressStr)
        var url = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/doctors/update.php?doctor_id='\(doctorId)'&doctorName='\(nameStr)'&doctorPhoneNumber='\(phoneNumberStr)'&doctorAddress='\(addressStr)'";
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
