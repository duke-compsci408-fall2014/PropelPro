//
//  ContactsVC.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/5/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import UIKit

class ContactsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var items: [Contact] = []
    
    var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.populateContacts()
    }
    
    func populateContacts() {
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/contacts/select.php?attribute=*&patient_id='\(self.deviceId)'"
        var url = NSURL(string: urlStr)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error!\n\(NSString(data: data, encoding: NSUTF8StringEncoding))")
            } else {
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                var jsonArray : JSONArray = JSONArray(str: output)
                self.items = [] // clear the old stuff first
                for obj : JSON in jsonArray.getObjects() {
                    var map : [String : String] = obj.getMap()
                    // TODO: update when recipient ID is available
                    var contact = Contact(id: map["contact_id"]!, name: map["contactName"]!, number: map["contactPhoneNumber"]!)
                    self.items.append(contact)
                    self.updateContactSettingsInTable(contact)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
        task.resume()
    }
    
    func updateContactSettingsInTable(var contact: Contact) {
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/notifications/select.php?attribute=*&patient_id='\(self.deviceId)'&contact_id='\(contact.contactId)'"
        var url = NSURL(string: urlStr)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error!\n\(NSString(data: data, encoding: NSUTF8StringEncoding))")
            } else {
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                var jsonArray : JSONArray = JSONArray(str: output)
                for statSetting : JSON in jsonArray.getObjects() {
                    var map : [String : String] = statSetting.getMap()
                    
                    var textsOn = map["textsOn"] == "1" // a boolean
                    var callsOn = map["callsOn"] == "1" // a boolean
                    
                    if (map["stat_id"] == "7") {
                        contact.stepsTuple = (statId:7, isText: textsOn, isCall: callsOn)
                    } else if (map["stat_id"] == "1") {
                        contact.bodyMassTuple = (statId:1, isText: textsOn, isCall: callsOn)
                    } else if (map["stat_id"] == "6") {
                        contact.oxyTuple = (statId:6, isText: textsOn, isCall: callsOn)
                    } else if (map["stat_id"] == "9") {
                        contact.hrTuple = (statId:9, isText: textsOn, isCall: callsOn)
                    } else {
                        println("stat id not found when populating contact settings!")
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
        task.resume()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var contact : Contact = self.items[indexPath.row]
        cell.textLabel.text = contact.toString()
        
        return cell
    }
    
    
    //deleting
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        ///dont delete - need for the sliding apparently, idk why for now
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit", handler:{action, indexpath in
            println("Edit•ACTION");
            
            //need to write edit action
            self.performSegueWithIdentifier("editContact", sender: indexPath)
            
            
        });
        
        editRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            
            println("DELETE•ACTION");
            
            var itemRemove : Contact = self.items[indexPath.row]
            self.items.removeAtIndex(indexPath.row)
            
            var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/contacts/delete.php?contact_id='\(itemRemove.contactId)'";
            println(urlStr);
            
            var url = StringHelper.cleanURLString(urlStr);
            
            self.makeHTTPRequest(url);
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        });
        
        return [deleteRowAction, editRowAction];
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    // This populates the edit fields before they are presented
    // sender is the index path of the cell
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "editContact" {
            println("preparing for edit contact segue")
            let vc = segue.destinationViewController as EditContactController
            var indexPath : NSIndexPath = sender as NSIndexPath//self.tableView.indexPathForSelectedRow()!
            var contact : Contact = self.items[indexPath.row]
            
            //pre populate the stuff
            vc.contactID = contact.contactId
            vc.name = contact.contactName
            vc.number = contact.contactPhoneNumber
            
            //pre populate the tuples
            vc.stepsNotificationTuple = contact.stepsTuple
            vc.bodyMassNotificationTuple = contact.bodyMassTuple
            vc.oxyNotificaitonTuple = contact.oxyTuple
            vc.hrNotificaitionTuple = contact.hrTuple
        }
    }

    
    //making http requests
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

