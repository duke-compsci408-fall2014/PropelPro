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
        static var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString;
        
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
        
        static var typeToUnitMap : [String : String]! = nil
        static func getTypeToUnitMap() -> [String : String] {
            if (ClassVars.typeToUnitMap == nil) {
                ClassVars.typeToUnitMap = [
                    HKQuantityTypeIdentifierBodyMass : "lb",
                    HKQuantityTypeIdentifierStepCount : "count",
                    HKQuantityTypeIdentifierHeartRate : "count/min",
                    HKQuantityTypeIdentifierOxygenSaturation : "%"
                ]
            }
            return ClassVars.typeToUnitMap
        }

        static var typeIdToStatId : [String : String]! = nil
        static func getTypeIdToStatIdMap() -> [String : String] {
            if (ClassVars.typeIdToStatId == nil) {
                ClassVars.typeIdToStatId = [
                    HKQuantityTypeIdentifierBodyMass : "1",
                    HKQuantityTypeIdentifierStepCount : "7",
                    HKQuantityTypeIdentifierHeartRate : "9",
                    HKQuantityTypeIdentifierOxygenSaturation : "6"
                ]
            }
            return ClassVars.typeIdToStatId
        }

        static var typeIdToCommonName : [String : String]! = nil
        static func getTypeIdToCommonNameMap() -> [String : String] {
            if (ClassVars.typeIdToCommonName == nil) {
                ClassVars.typeIdToCommonName = [
                    HKQuantityTypeIdentifierBodyMass : "body mass",
                    HKQuantityTypeIdentifierStepCount : "step count",
                    HKQuantityTypeIdentifierHeartRate : "heart rate",
                    HKQuantityTypeIdentifierOxygenSaturation : "oxygen saturation"
                ]
            }
            return ClassVars.typeIdToCommonName
        }
}
    
    
    class func getStore() -> HKHealthStore {
        return ClassVars.getStore()
    }
    
    class func initializeStore() {
        var shareSet : NSSet = NSSet()
        var readSet  : NSSet = getTypesToReadSet()
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
        var types : NSSet = getTypesToReadSet()
        
        for type in types {
            var observerQuery : HKObserverQuery = HKObserverQuery(sampleType: type as HKQuantityType, predicate: nil, updateHandler: observerQueryHandler)
            getStore().executeQuery(observerQuery)
            
            var freq : HKUpdateFrequency = HKUpdateFrequency.Immediate
            // special case: step count may not have immediate frequency
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
            var unitString = ClassVars.getTypeToUnitMap()[typeIdentifier]! as String
            var unit : HKUnit = HKUnit(fromString: unitString)
            var value : Double = result.quantity.doubleValueForUnit(unit)
            println("Quantity: \(value) \(unitString)")
            
            fetchBoundsForTypeId(value, typeId: typeIdentifier);
        }
    }
    
    class func fetchBoundsForTypeId(value: Double, typeId : String) {
        var statId = ClassVars.getTypeIdToStatIdMap()[typeId]
        var urlStr = "http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/bounds/select.php?attribute=*&patient_id='\(ClassVars.deviceId)'&stat_id='\(statId!)'"
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
                
                // TODO: if the value is outside of the bounds, make notification
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
        
        var patientId = ClassVars.deviceId
        var statName = ClassVars.getTypeIdToCommonNameMap()[typeId]! as String
        var statUnit = ClassVars.getTypeToUnitMap()[typeId]! as String
        
        // get patient name first
        var cleanUrl = StringHelper.cleanURLString("http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/patients/select.php?attribute=*&patient_id='\(patientId)'")
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
                var statId = ClassVars.typeIdToStatId[typeId]!
                
                // we need to get all contacts to text
                var cleanUrl2 = StringHelper.cleanURLString("http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/notifications/getAllTextsOn.php?patient_id='\(patientId)'&stat_id='\(statId)'")
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
                            println("TEXT! name: \(recipName), number: \(recipNumber), stat: \(statName)")
                            
                            var twilioTextUrlStr = "http://dukecs408-twilio.herokuapp.com/notifyWithText?recipientName=\(recipName)&patientName=\(name!)&recipientPhoneNumber=\(recipNumber)&statName=\(statName)&statValue=\(value)&statUnit=\(statUnit)&statLowerBound=\(lowerBound)&statUpperBound=\(upperBound)"
                            twilioTextUrlStr = StringHelper.cleanURLString(twilioTextUrlStr)
                            println("twilio url:")
                            println(twilioTextUrlStr)
                            GlobalHealthStore.makeHTTPRequest(twilioTextUrlStr)
                        }
                    }
                }
                task2.resume()
                
                
                // we need to get all contacts to call
                var cleanUrl3 = StringHelper.cleanURLString("http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/notifications/getAllCallsOn.php?patient_id='\(patientId)'&stat_id='\(statId)'")
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
                            println("CALL! name: \(recipName), number: \(recipNumber), stat: \(statName)")
                            
                            var twilioCallUrlStr = "http://dukecs408-twilio.herokuapp.com/notifyWithCall?recipientName=\(recipName)&patientName=\(name!)&recipientPhoneNumber=\(recipNumber)&statName=\(statName)&statValue=\(value)&statUnit=\(statUnit)&statLowerBound=\(lowerBound)&statUpperBound=\(upperBound)"
                            twilioCallUrlStr = StringHelper.cleanURLString(twilioCallUrlStr)
                            println("twilio url:")
                            println(twilioCallUrlStr)
                            GlobalHealthStore.makeHTTPRequest(twilioCallUrlStr)

                        }
                    }
                }
                task3.resume()
                
                // finally text all the doctors
                // we need to get all contacts to call
                var cleanUrl4 = StringHelper.cleanURLString("http://colab-sbx-211.oit.duke.edu/PHPDatabaseCalls/doctors/select.php?attribute=*&patient_id='\(patientId)'")
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
                            println("TEXT DOCTOR! name: \(recipName), number: \(recipNumber), stat: \(statName)")
                            
                            var twilioDoctorUrlStr = "http://dukecs408-twilio.herokuapp.com/notifyWithText?recipientName=\(recipName)&patientName=\(name!)&recipientPhoneNumber=\(recipNumber)&statName=\(statName)&statValue=\(value)&statUnit=\(statUnit)&statLowerBound=\(lowerBound)&statUpperBound=\(upperBound)"
                            twilioDoctorUrlStr = StringHelper.cleanURLString(twilioDoctorUrlStr)
                            println(twilioDoctorUrlStr)
                            GlobalHealthStore.makeHTTPRequest(twilioDoctorUrlStr)
                            
                        }
                    }
                }
                task4.resume()
            }
        }
        task.resume()

    }
    
    class func backgroundDeliveryEnabled(success : Bool, error: NSError!) {
        if (error != nil) {
            println(error.localizedDescription)
            return
        }
        println("background delivery enabled! \(success)")
    }
    
    // This is an abridged list of types that can be read. Full list is here: https://developer.apple.com/library/ios/documentation/HealthKit/Reference/HealthKit_Constants/index.html#//apple_ref/doc/constant_group/Body_Measurements
    class func getTypesToReadSet() -> NSSet {
        var typesToRead : [HKObjectType] = []
        
        // Body mass
        typesToRead.append(HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass))
        
        // Heart rate
        typesToRead.append(HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate))

        // Oxygen level
        typesToRead.append(HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierOxygenSaturation))
        
        // Step count
        typesToRead.append(HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount))

        var readSet  : NSSet = NSSet(array: typesToRead)
        return readSet
    }

    class func makeHTTPRequest(urlStringWithParameters : String) {
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

    
    
    
    /*
        Example HK functions below:
    */
    
    /*
    
    class func printCharacteristics() {
        var sex : HKBiologicalSexObject = getStore().biologicalSexWithError(nil)
        var blood : HKBloodTypeObject = getStore().bloodTypeWithError(nil)
        var dob : NSDate = getStore().dateOfBirthWithError(nil)
        println("Gender: \(sex.biologicalSex.rawValue)")
        println("Blood type: \(blood.bloodType.rawValue)")
        println("DOB: \(dob.description)")
    }
    
    // queries the most recent result
    class func testHeartRateQuery() {
        var hrType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        var endKey : NSString = HKSampleSortIdentifierEndDate
        var endDate : NSSortDescriptor = NSSortDescriptor(key: endKey, ascending: false)
        var query : HKSampleQuery = HKSampleQuery(sampleType: hrType, predicate: nil, limit: 1, sortDescriptors: [endDate], resultsHandler: queryHandler) // limit of 0 means no limit
        getStore().executeQuery(query)
    }

    class func testHeartRateObserverQuery() {
        var hrType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        var endKey : NSString = HKSampleSortIdentifierEndDate
        var endDate : NSSortDescriptor = NSSortDescriptor(key: endKey, ascending: false)
        var observerQuery : HKObserverQuery = HKObserverQuery(sampleType: hrType, predicate: nil, updateHandler: observerQueryHandler)
        getStore().executeQuery(observerQuery)
    }
    
    // TODO: We will need a mechanism to map type strings to type classes to units
    // Then we can have a single result handler to handle results of any type
    class func queryHandler(query: HKSampleQuery!, results: [AnyObject]!, error: NSError!) {
        if (error != nil) {
            println("hrResult error")
            println(error.localizedDescription)
            return
        }
        println("\(results.count) results returned!")
        println("Type: \(query.sampleType.identifier)")
        for result in results as [HKQuantitySample]! {
            var value : Double = result.quantity.doubleValueForUnit(HKUnit(fromString: "count/min"))
            println("Quantity: \(value)")
        }
    }
    
    class func observerQueryHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: NSError!) {
        println("new data available for \(query.sampleType.identifier)")
        
        // execute query for this data type
        // TODO: should specify the type in the call
        testHeartRateQuery()
        
        completionHandler()
    }
    
    class func testBackgroundDelivery() {
        var hrType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        getStore().enableBackgroundDeliveryForType(hrType, frequency: HKUpdateFrequency.Immediate, withCompletion: backgroundDeliveryEnabled)
    }
    */
}
