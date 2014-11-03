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
    
    var items: [String] = []
    
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
                var output = NSString(data: data, encoding: NSUTF8StringEncoding)
                println(output)
                // TODO: Format and present this data
                
                self.items.append(output!)
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
        
        cell.textLabel.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
    }
}

