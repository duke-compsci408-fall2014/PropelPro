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
    
    //tuple - (text, call)
    var stepHighLightTuple = (text:-1,call:-1)
    var bodyMassHighLightTuple = (text:-1,call:-1)
    var oxyHighLightTuple = (text:-1,call:-1)
    var hRHighLightTuple = (text:-1,call:-1)
    
//    var isStepTextHighLighted:Int = -1
//    var isBodyMassTextHighLighted:Int = -1
//    var isOxySelectTextHighLighted:Int = -1
//    var isHRTextHighLighted:Int = -1
//    
//    var isStepCallHighLighted:Int = -1
//    var isBodyMassCallHighLighted:Int = -1
//    var isOxySelectCallHighLighted:Int = -1
//    var isHRCallHighLighted:Int = -1
    
    var stepsNotificationTuple = (statId:7, isText: false, isCall: false)
    var bodyMassNotificationTuple = (statId: 1,isText: false, isCall: false)
    var oxyNotificaitonTuple = (statId: 6, isText: false,isCall: false)
    var hrNotificaitionTuple = (statId: 9,isText: false,isCall: false)
    
    //tuple - (stat_id, text_on, call_on)
    
//    var isTextStep:Bool = false
//    var isTextOxi:Bool = false
//    var isTextHR:Bool = false
//    var isTextBM:Bool = false
//    
//    var isCallStep:Bool = false
//    var isCallOxi:Bool = false
//    var isCallHR:Bool = false
//    var isCallBM:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        saveButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //keyboard hiding after editing text field
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // button for enable / disable text
    @IBAction func stepTextSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.stepHighLightTuple.text == -1) {
                sender.highlighted = true;
                self.stepsNotificationTuple.isText = true;
                self.stepHighLightTuple.text = 0;
            }else{
                sender.highlighted = false;
                self.stepHighLightTuple.text = -1;
                self.stepsNotificationTuple.isText = false;
            }
        });
    }
    
    @IBAction func bodyMassTextSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.bodyMassHighLightTuple.text == -1){
                sender.highlighted = true;
                self.bodyMassNotificationTuple.isText = true;
                self.bodyMassHighLightTuple.text = 1;
            }else{
                sender.highlighted = false;
                self.bodyMassNotificationTuple.isText = false;
                self.bodyMassHighLightTuple.text = -1;
            }
        });
    }
    
    @IBAction func oxyTextSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.oxyHighLightTuple.text == -1){
                sender.highlighted = true;
                self.oxyNotificaitonTuple.isText = true;
                self.oxyHighLightTuple.text = 2;
            }else{
                sender.highlighted = false;
                self.oxyNotificaitonTuple.isText = false;
                self.oxyHighLightTuple.text = -1;
            }
        });
    }
    
    @IBAction func hrTextSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.hRHighLightTuple.text == -1){
                sender.highlighted = true;
                self.hrNotificaitionTuple.isText = true;
                self.hRHighLightTuple.text = 3;
            }else{
                sender.highlighted = false;
                self.hrNotificaitionTuple.isText = false
                self.hRHighLightTuple.text = -1;
            }
        });
    }
    
    //button action for enable / disable calls
    
    @IBAction func stepCallSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.stepHighLightTuple.call == -1) {
                sender.highlighted = true;
                self.stepsNotificationTuple.isCall = true;
                self.stepHighLightTuple.call = 0;
            }else{
                sender.highlighted = false;
                self.stepsNotificationTuple.isCall = false;
                self.stepHighLightTuple.call = -1;
            }
        });
    }
    
    @IBAction func bodyMassCallSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.bodyMassHighLightTuple.call == -1){
                sender.highlighted = true;
                self.bodyMassNotificationTuple.isCall = true;
                self.bodyMassHighLightTuple.call = 1;
            }else{
                sender.highlighted = false;
                self.bodyMassNotificationTuple.isCall = false;
                self.bodyMassHighLightTuple.call = -1;
            }
        });
        
    }
    
    @IBAction func oxyCallSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.oxyHighLightTuple.call == -1){
                sender.highlighted = true;
                self.oxyNotificaitonTuple.isCall = true;
                self.oxyHighLightTuple.call = 2;
            }else{
                sender.highlighted = false;
                self.oxyNotificaitonTuple.isCall = false;
                self.oxyHighLightTuple.call = -1;
            }
        });
    }
    
    @IBAction func hrCallSelect(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if (self.hRHighLightTuple.call == -1){
                sender.highlighted = true;
                self.hrNotificaitionTuple.isCall = true;
                self.hRHighLightTuple.call = 3;
            }else{
                sender.highlighted = false;
                self.hrNotificaitionTuple.isCall = false
                self.hRHighLightTuple.call = -1;
            }
        });
        
    }
    
    
    // this is what happened when save is pressed
    
    func buttonAction(sender:UIButton!)
    {
        var patientId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        var nameStr : String = nameField.text;
        var phoneNumberStr : String = phoneNumberField.text;
//        let statIds = ["7","1","6","9"];
        var notifications = [self.stepHighLightTuple,self.bodyMassHighLightTuple,self.oxyHighLightTuple,self.hRHighLightTuple]
        var statIdSelections = [self.stepsNotificationTuple,self.bodyMassNotificationTuple,self.oxyNotificaitonTuple,self.hrNotificaitionTuple];
        
        // insert the contact
        var url = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/contacts/insertAll.php?patient_id='\(patientId)'&contactName='\(nameStr)'&contactPhoneNumber='\(phoneNumberStr)'";
        url = StringHelper.cleanURLString(url)

        let nsurl = NSURL(string: url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(nsurl!) {(data, response, error) in
            if error != nil {
                println("error! \(NSString(data: data, encoding: NSUTF8StringEncoding))")
            } else {
                println("inserted contact! \(NSString(data: data, encoding: NSUTF8StringEncoding))")
                var contactId = NSString(data: data, encoding: NSASCIIStringEncoding) as String
                println(contactId)
                // update all notifications for this contact
                for i in 0...notifications.count-1 {
                    var notificationsUrl = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/notifications/update.php?patient_id='\(patientId)'&contact_id='\(contactId)'&stat_id='\(statIdSelections[i].statId)'&textsOn=\(statIdSelections[i].isText)&callsOn=\(statIdSelections[i].isCall)";
                    notificationsUrl = StringHelper.cleanURLString(notificationsUrl)
                    println(notificationsUrl)
                    self.makeHTTPRequest(notificationsUrl)
                }
            }
        }
        task.resume()
}
    
    func checkSelected(tuple : (text:Int,call:Int)) -> Bool{
        if(tuple.text != -1 || tuple.call != -1){
            return true;
        }
        return false;
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

