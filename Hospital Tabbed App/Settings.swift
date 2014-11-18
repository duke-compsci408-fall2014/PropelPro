//
//  Settings.swift
//  Hospital Tabbed App
//
//  Created by Wei Chen on 11/17/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation
import UIKit

class Settings : UIViewController, UITableViewDelegate {
    //oximeter
    @IBOutlet weak var oxiSave: UIButton!
    @IBOutlet weak var oxiHigh: UITextField!
    @IBOutlet weak var oxiLow: UITextField!
    let oxiId = "6";

    //pedometer
    @IBOutlet weak var pedoSave: UIButton!
    @IBOutlet weak var pedoLow: UITextField!
    @IBOutlet weak var pedoHigh: UITextField!
    let pedoId = "7";
    
    //heart rate
    @IBOutlet weak var hrSave: UIButton!
    @IBOutlet weak var hrLow: UITextField!
    @IBOutlet weak var hrHigh: UITextField!
    let hrId = "9"
    
    //body mass
    @IBOutlet weak var bmSave: UIButton!
    @IBOutlet weak var bmLow: UITextField!
    @IBOutlet weak var bmHigh: UITextField!
    let weightId = "1"
    
    //device Id
    let patient_id = UIDevice.currentDevice().identifierForVendor.UUIDString;
    
    
    

    
    @IBAction func OxiSave(sender: AnyObject) {
        var lowbound = oxiLow.text
        var highbound = oxiHigh.text
        
        println("saving oxi")
        self.save(patient_id,stat_id: oxiId,lowerBound: lowbound,upperBound: highbound)
    }
    
    @IBAction func pedoSave(sender: AnyObject) {
        var lowbound = pedoLow.text
        var highbound = pedoHigh.text
        
        println("saving pedo")
        self.save(patient_id,stat_id: pedoId,lowerBound: lowbound,upperBound: highbound)
    }
    
    @IBAction func hrSave(sender: AnyObject) {
        var lowbound = hrLow.text
        var highbound = hrHigh.text
        
        println("saving heart rate")
        self.save(patient_id,stat_id: hrId,lowerBound: lowbound,upperBound: highbound)
    }
    
    @IBAction func bmSave(sender: AnyObject) {
        var lowbound = bmLow.text
        var highbound = bmHigh.text
        
        println("saving weight limit")
        self.save(patient_id,stat_id: weightId,lowerBound: lowbound,upperBound: highbound)
    }
    
    
    
    
    
    func save(patient_id:String,stat_id:String,lowerBound:String,upperBound:String){
        println(patient_id)
        println(stat_id)
        println(lowerBound)
        println(upperBound)
        
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/bounds/insert.php?patient_id='\(patient_id)'&stat_id='\(stat_id)'&statLowerBound='\(lowerBound)'&statUpperBound='\(upperBound)'";
        
        var url = StringHelper.cleanURLString(urlStr);
        
        self.makeHTTPRequest(url);

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

