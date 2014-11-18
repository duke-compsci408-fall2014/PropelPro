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
    var isStepHighLighted:Int = -1
    var isBodyMassHighLighted:Int = -1
    var isOxySelectHighLighted:Int = -1
    var isHRHighLighted:Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        saveButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @IBAction func stepSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.isStepHighLighted == -1) {
                sender.highlighted = true;
                self.isStepHighLighted = 0;
            }else{
                sender.highlighted = false;
                self.isStepHighLighted = -1;
            }
        });
    }
    
    @IBAction func bodyMassSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.isBodyMassHighLighted == -1){
                sender.highlighted = true;
                self.isBodyMassHighLighted = 1;
            }else{
                sender.highlighted = false;
                self.isBodyMassHighLighted = -1;
            }
        });
    }
    
    @IBAction func OxySelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.isOxySelectHighLighted == -1){
                sender.highlighted = true;
                self.isOxySelectHighLighted = 2;
            }else{
                sender.highlighted = false;
                self.isOxySelectHighLighted = -1;
            }
        });
    }
    
    @IBAction func hrSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.isHRHighLighted == -1){
                sender.highlighted = true;
                self.isHRHighLighted = 3;
            }else{
                sender.highlighted = false;
                self.isHRHighLighted = -1;
            }
        });
    }
    
    
    func buttonAction(sender:UIButton!)
    {
        var patientId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        var nameStr : String = nameField.text;
        var phoneNumberStr : String = phoneNumberField.text;
        let statIds = ["7","1","6","9"];
        var statIdSelections = [self.isStepHighLighted,self.isBodyMassHighLighted,self.isOxySelectHighLighted,self.isHRHighLighted];
        
        println(nameStr)
        println(phoneNumberStr)
        var repeat = "";
        for i in statIdSelections {
            if( i != -1){
        
                var url = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/contacts/insert.php?patient_id='\(patientId)'&contactName='\(nameStr)'&contactPhoneNumber='\(phoneNumberStr)'&stat_id=\(statIds[i])&repeat=\(repeat)";
                println("dirty url:" + url);
                url = StringHelper.cleanURLString(url)
//                println("clean url:" + url);
                makeHTTPRequest(url)
                repeat = "true"
            }
        }
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

