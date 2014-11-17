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
    let oximeterId = 6;

    //pedometer
    @IBOutlet weak var pedoSave: UIButton!
    @IBOutlet weak var pedoLow: UITextField!
    @IBOutlet weak var pedoHigh: UITextField!
    let pedometerId = 7;
    //device Id
    let deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;

    
    
    func save(sender:UIButton!){

        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/bounds/select.php?attribute=*&patient_id='\(deviceId)'&stat_id='\(oximeterId)";
        
        var url = NSURL(string: urlStr);

        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error!\n\(NSString(data: data, encoding: NSUTF8StringEncoding))")
            } else {
                println("success!")
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                println(output)
                if(!self.checkExistance(output)){
                    //insert the name
                    
                    
                    
                }else{
                    //update existing data
                    
                    
                    
                    
                }
            }
        }
    }
    
    func checkExistance(urlOutput:String)->Bool{
        if(urlOutput == ""){
            return false
        }
        return true
    }
    
    func update(patientID:String, statId:Int, lowerInput:String, upperInput:String){
        println(patientID)
        println(statId)
        println(lowerInput)
        println(upperInput)
        
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/bounds/update.php?patient_id='\(patientID)'&stat_id='\(statId)'&statLowerBound='\(lowerInput)'&statUpperBound='\(upperInput)"
        var url = StringHelper.cleanURLString(urlStr)
        makeHTTPRequest(url)
        
    }
    
    func insert(patientID:String, statId:Int, lowerInput:String, upperInput:String){
        println(patientID)
        println(statId)
        println(lowerInput)
        println(upperInput)
        
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/bounds/insert.php?patient_id='\(patientID)'&stat_id='\(statId)'&statLowerBound='\(lowerInput)'&statUpperBound='\(upperInput)"
        var url = StringHelper.cleanURLString(urlStr)
        
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

