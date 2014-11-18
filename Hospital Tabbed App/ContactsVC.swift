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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.populateContacts()
    }
    
    func populateContacts() {
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        println("Device ID: \(deviceId)");
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/contacts/select.php?attribute=*&patient_id='\(deviceId)'"
        var url = NSURL(string: urlStr)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error!\n\(NSString(data: data, encoding: NSUTF8StringEncoding))")
            } else {
                println("success!")
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                println(output)
                var jsonArray : JSONArray = JSONArray(str: output)
                self.items = [] // clear the old stuff first
                for obj : JSON in jsonArray.getObjects() {
                    var map : [String : String] = obj.getMap()
                    // TODO: update when recipient ID is available
                    var contact = Contact(id: map["contact_id"]!, name: map["contactName"]!, number: map["contactPhoneNumber"]!)
                    self.items.append(contact)
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
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var itemRemove : Contact = self.items[indexPath.row]
            self.items.removeAtIndex(indexPath.row)
            
            var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/contacts/delete.php?contact_id='\(itemRemove.contactId)'";
            println(urlStr);
            
            var url = StringHelper.cleanURLString(urlStr);
            
            self.makeHTTPRequest(url);
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    
    //testing table row expansion
    var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    var cellTapped = false
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
        selectedRowIndex = indexPath
        println("beginning updates")
        tableView.beginUpdates()
        println("beginning ending updates")
        tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.row == selectedRowIndex.row {
            if cellTapped == false {
                cellTapped = true
                println(indexPath.row)
                
                return 150
            } else {
                cellTapped = false
                return 45
            }
        }
        return 45
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

