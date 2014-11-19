//
//  DoctorsVC.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/3/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import UIKit

class DoctorsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var items: [Doctor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.populateDoctors()
    }
    
    func populateDoctors() {
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        println("Device ID: \(deviceId)");
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/doctors/select.php?attribute=*&patient_id='\(deviceId)'"
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
                    var doc = Doctor(id: map["doctor_id"]!, name: map["doctorName"]!, number: map["doctorPhoneNumber"]!, address: map["doctorAddress"]!)
                    self.items.append(doc)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
        task.resume()
    }
    
    //deleting
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var itemRemove : Doctor = self.items[indexPath.row]
            self.items.removeAtIndex(indexPath.row)
            
            var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/doctors/delete.php?doctor_id='\(itemRemove.doctorId)'";
            println(urlStr);
            
            var url = StringHelper.cleanURLString(urlStr);
            
            self.makeHTTPRequest(url);
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var doc : Doctor = self.items[indexPath.row]
        cell.textLabel.text = doc.toString()
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
        self.performSegueWithIdentifier("editDoctor", sender: self)
    }
    
    // This populates the edit fields before they are presented
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "editDoctor" {
            println("preparing for edit doctor segue")
            let vc = segue.destinationViewController as EditDoctorVC
            var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow()!
            var doc : Doctor = self.items[indexPath.row]
            vc.doctorId = doc.doctorId
            vc.doctorName = doc.doctorName
            vc.doctorPhoneNumber = doc.doctorPhoneNumber
            vc.doctorAddress = doc.doctorAddress
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

