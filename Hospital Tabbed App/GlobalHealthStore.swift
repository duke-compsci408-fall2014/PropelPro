//
//  Globals.swift
//  Hello
//
//  Created by Chinmay Patwardhan on 11/10/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

// Swift doesn't support class variables yet
// Hack: make a private struct that stores a static variable, and then provide
//       a class function to return the static variable

class GlobalHealthStore {
    private struct ClassVars {
        static var store : HKHealthStore! = nil;
        static func getStore() -> HKHealthStore {
            if (ClassVars.store == nil) {
                ClassVars.store = HKHealthStore()
                if HKHealthStore.isHealthDataAvailable() {
                    println("health data is available")
                    GlobalHealthStore.initializeStore()
                } else {
                    println("health data NOT available")
                }
            }
            return ClassVars.store
        }
    }
    
    
    class func getStore() -> HKHealthStore {
        return ClassVars.getStore()
    }
    
    class func initializeStore() {
        var shareSet : NSSet = NSSet()
        var readSet  : NSSet = Constants.getTypesToReadSet()
        getStore().requestAuthorizationToShareTypes(shareSet, readTypes: readSet, completion: storeRequestAuthorizedHandler)
    }
    
    // This function subscribes to events for all the data types we care about
    class func storeRequestAuthorizedHandler(success : Bool, error : NSError!) {
        if success {
            println("successfully authorized")
            placeAllObserverQueriesAndBackgroundDeliveries()
        }
    }
    
    class func placeAllObserverQueriesAndBackgroundDeliveries() {
        var endKey : NSString = HKSampleSortIdentifierEndDate
        var endDate : NSSortDescriptor = NSSortDescriptor(key: endKey, ascending: false)
        var types : NSSet = Constants.getTypesToReadSet()
        
        for type in types {
            var observerQuery : HKObserverQuery = HKObserverQuery(sampleType: type as HKQuantityType, predicate: nil, updateHandler: observerQueryHandler)
            getStore().executeQuery(observerQuery)
            
            var freq : HKUpdateFrequency = HKUpdateFrequency.Immediate
            // special case: Health Kit doesn't allowed step count to have immediate frequency
            if (type.identifier == HKQuantityTypeIdentifierStepCount) {
                freq = HKUpdateFrequency.Hourly
            }
            getStore().enableBackgroundDeliveryForType(type as HKQuantityType, frequency: freq, withCompletion: backgroundDeliveryEnabled)
        }
    }
    
    class func observerQueryHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: NSError!) {
        println("new data available for \(query.sampleType.identifier)")
        
        // execute query for this data type
        var type : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(query.sampleType.identifier)
        placeQuery(type)
        
        completionHandler()
    }
    
    class func placeQuery(type: HKQuantityType) {
        var endKey : NSString = HKSampleSortIdentifierEndDate
        var endDate : NSSortDescriptor = NSSortDescriptor(key: endKey, ascending: false)
        var query : HKSampleQuery = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [endDate], resultsHandler: queryHandler) // limit of 0 means no limit
        getStore().executeQuery(query)
    }
    
    class func queryHandler(query: HKSampleQuery!, results: [AnyObject]!, error: NSError!) {
        if (error != nil) {
            println(error.localizedDescription)
            return
        }
        var typeIdentifier : String = query.sampleType.identifier
        println("\(results.count) results returned of type \(typeIdentifier).")
        
        for result in results as [HKQuantitySample]! {
            var unitString = Constants.getTypeToUnitMap()[typeIdentifier]! as String
            var unit : HKUnit = HKUnit(fromString: unitString)
            var value : Double = result.quantity.doubleValueForUnit(unit)
            println("Quantity: \(value) \(unitString)")
            
            fetchBoundsForTypeId(value, typeId: typeIdentifier);
        }
    }
    
    class func fetchBoundsForTypeId(value: Double, typeId : String) {
        var statId = Constants.getTypeIdToStatIdMap()[typeId]
        var urlStr = "\(Constants.URL_BOUNDS_SELECT)attribute=*&patient_id='\(Constants.DEVICE_ID)'&stat_id='\(statId!)'"
        let url = NSURL(string: urlStr)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                println("error! \(NSString(data: data, encoding: NSUTF8StringEncoding))")
            } else {
                println("success!")
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                var objects : [JSON] = JSONArray(str: output).getObjects()
                if (objects.count == 0) {
                    println("no bounds available")
                    return
                }
                var object = objects[0]
                var map : [String : String] = object.getMap()
                var lowBound = NSString(string: map["statLowerBound"]!).doubleValue
                var upBound  = NSString(string: map["statUpperBound"]!).doubleValue
                
                println("value:\(value), low:\(lowBound), up:\(upBound)")
                GlobalHealthStore.actInResponseToBounds(value, lowerBound: lowBound, upperBound: upBound, typeId: typeId)
            }
        }
        task.resume()
    }
    
    // queries:
    // recipientName,  <-- needs to be found via http
    // patientName, <-- needs to be found via http
    // recipientPhoneNumber, <-- needs to be found via http
    // statName, <-- found in map
    // statUnit, <-- found in map
    // statValue,
    // statLowerBound,
    // statUpperBound
    class func actInResponseToBounds(value: Double, lowerBound: Double, upperBound: Double, typeId: String) {
        if (value >= lowerBound && value <= upperBound) {
            return; // all is well in the world. no alert is sent
        }
        
        var patientId = Constants.DEVICE_ID
        var statName = Constants.getTypeIdToCommonNameMap()[typeId]! as String
        var statUnit = Constants.getTypeToUnitMap()[typeId]! as String
        
        var valueStr = "\(value)"
        var lowerBoundStr = "\(lowerBound)"
        var upperBoundStr = "\(upperBound)"
        
        // get patient name first
        var cleanUrl = StringHelper.cleanURLString("\(Constants.URL_PATIENTS_SELECT)attribute=*&patient_id='\(patientId)'")
        var nameUrl = NSURL(string: cleanUrl)
        let task = NSURLSession.sharedSession().dataTaskWithURL(nameUrl!) {(data, response, error) in
            if error != nil {
                println("error finding patient name")
            } else {
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                var patient : JSON? = nil
                var name : String? = nil
                if output.isEmpty || output == "200" {
                    name = "[unkown]"
                } else {
                    patient = JSONArray(str: output).getObjects()[0]
                    name = patient!.getMap()["patientName"]!
                }
                
                // At this point, we have the name. Now we need contacts.
                var statId = Constants.getTypeIdToStatIdMap()[typeId]!
                
                // we need to get all contacts to text
                var cleanUrl2 = StringHelper.cleanURLString("\(Constants.URL_NOTIFICATIONS_GET_ALL_TEXTS_ON)patient_id='\(patientId)'&stat_id='\(statId)'")
                var textsUrl = NSURL(string: cleanUrl2)
                let task2 = NSURLSession.sharedSession().dataTaskWithURL(textsUrl!) {(data, response, error) in
                    if error != nil {
                        println("error finding contacts to text")
                    } else {
                        var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                        var contacts : [JSON] = JSONArray(str: output).getObjects()
                        for contact : JSON in contacts {
                            var map = contact.getMap()
                            var recipName = map["contactName"]!
                            var recipNumber = map["contactPhoneNumber"]!
                            GlobalHealthStore.makeNotification(Constants.NOTIFICATION_TYPE_TEXT, recipName:recipName, name: name!, recipNumber: recipNumber, statName: statName, value: valueStr, statUnit: statUnit, lowerBound: lowerBoundStr, upperBound: upperBoundStr)
                        }
                    }
                }
                task2.resume()
                
                
                // we need to get all contacts to call
                var cleanUrl3 = StringHelper.cleanURLString("\(Constants.URL_NOTIFICATIONS_GET_ALL_CALLS_ON)patient_id='\(patientId)'&stat_id='\(statId)'")
                var callsUrl = NSURL(string: cleanUrl3)
                let task3 = NSURLSession.sharedSession().dataTaskWithURL(callsUrl!) {(data, response, error) in
                    if error != nil {
                        println("error finding contacts to call")
                    } else {
                        var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                        var contacts : [JSON] = JSONArray(str: output).getObjects()
                        for contact : JSON in contacts {
                            var map = contact.getMap()
                            var recipName = map["contactName"]!
                            var recipNumber = map["contactPhoneNumber"]!
                            GlobalHealthStore.makeNotification(Constants.NOTIFICATION_TYPE_CALL, recipName:recipName, name: name!, recipNumber: recipNumber, statName: statName, value: valueStr, statUnit: statUnit, lowerBound: lowerBoundStr, upperBound: upperBoundStr)

                        }
                    }
                }
                task3.resume()
                
                // finally text all the doctors
                // we need to get all contacts to call
                var cleanUrl4 = StringHelper.cleanURLString("\(Constants.URL_DOCTORS_SELECT)attribute=*&patient_id='\(patientId)'")
                var doctorsUrl = NSURL(string: cleanUrl4)
                let task4 = NSURLSession.sharedSession().dataTaskWithURL(doctorsUrl!) {(data, response, error) in
                    if error != nil {
                        println("error finding doctors to text")
                    } else {
                        var output = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                        var doctors : [JSON] = JSONArray(str: output).getObjects()
                        for doctor : JSON in doctors {
                            var map = doctor.getMap()
                            var recipName = map["doctorName"]!
                            var recipNumber = map["doctorPhoneNumber"]!
                            GlobalHealthStore.makeNotification(Constants.NOTIFICATION_TYPE_TEXT, recipName:recipName, name: name!, recipNumber: recipNumber, statName: statName, value: valueStr, statUnit: statUnit, lowerBound: lowerBoundStr, upperBound: upperBoundStr)
                        }
                    }
                }
                task4.resume()
            }
        }
        task.resume()

    }
    
    class func makeNotification(notificationType:String, recipName:String, name:String, recipNumber:String, statName:String, value:String, statUnit:String, lowerBound:String, upperBound:String) {
        
        if Constants.DEBUG_NOTIFICATIONS_ON == false {
            println("\(notificationType) suppressed because DEBUG_NOTIFICATIONS_ON is set to false")
            return
        }
        
        var baseUrl = ""
        if notificationType == Constants.NOTIFICATION_TYPE_TEXT {
            baseUrl = Constants.URL_TWILIO_TEXTS
        } else if notificationType == Constants.NOTIFICATION_TYPE_CALL {
            baseUrl = Constants.URL_TWILIO_CALLS
        }
        
        var twilioTextUrlStr = "\(baseUrl)recipientName=\(recipName)&patientName=\(name)&recipientPhoneNumber=\(recipNumber)&statName=\(statName)&statValue=\(value)&statUnit=\(statUnit)&statLowerBound=\(lowerBound)&statUpperBound=\(upperBound)"
        twilioTextUrlStr = StringHelper.cleanURLString(twilioTextUrlStr)
        println(twilioTextUrlStr)
        HTTPHelper.makeHTTPRequest(twilioTextUrlStr)
    }
    
    class func backgroundDeliveryEnabled(success : Bool, error: NSError!) {
        if (error != nil) {
            println(error.localizedDescription)
            return
        }
        println("background delivery enabled! \(success)")
    }
}
