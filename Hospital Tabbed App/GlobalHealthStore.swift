//
//  Globals.swift
//  Hello
//
//  Created by Chinmay Patwardhan on 11/10/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation
import HealthKit

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
        var readSet  : NSSet = getTypesToReadSet()
        getStore().requestAuthorizationToShareTypes(shareSet, readTypes: readSet, completion: storeRequestAuthorizedHandler)
    }
    
    class func storeRequestAuthorizedHandler(success : Bool, error : NSError!) {
        if success {
            println("successfully authorized")
            printCharacteristics()
            //            testHeartRateQuery()
            testHeartRateObserverQuery()
            //            testBackgroundDelivery()
        }
    }
    
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
        
        // execute query for this data type TODO: should specify the type in the call
        testHeartRateQuery()
        
        completionHandler()
    }
    
    class func testBackgroundDelivery() {
        var hrType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        getStore().enableBackgroundDeliveryForType(hrType, frequency: HKUpdateFrequency.Immediate, withCompletion: backgroundDeliveryEnabled)
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
        
        // Gender
        typesToRead.append(HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex))
        
        // Blood type
        typesToRead.append(HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType))
        
        // Date of birth
        typesToRead.append(HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth))
        
        // Body mass
        typesToRead.append(HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass))
        
        // Heart rate
        typesToRead.append(HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate))
        
        var readSet  : NSSet = NSSet(array: typesToRead)
        return readSet
    }
    
}
