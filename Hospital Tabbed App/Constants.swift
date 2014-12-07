//
//  Constants.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 12/7/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import UIKit
import HealthKit

struct Constants {
    // This gets the UUID of the current device, which is used as the patient ID
    static var DEVICE_ID = UIDevice.currentDevice().identifierForVendor.UUIDString;
    
    
    // Base URLs for Database API:
    private static var URL_DB_SERVER = "http://colab-sbx-211.oit.duke.edu"
    static let URL_BOUNDS_INSERT = "\(URL_DB_SERVER)/PHPDatabaseCalls/bounds/insert.php?"
    static let URL_BOUNDS_SELECT = "\(URL_DB_SERVER)/PHPDatabaseCalls/bounds/select.php?"
    
    static let URL_CONTACTS_DELETE = "\(URL_DB_SERVER)/PHPDatabaseCalls/contacts/delete.php?"
    static let URL_CONTACTS_INSERT_ALL = "\(URL_DB_SERVER)/PHPDatabaseCalls/contacts/insert.php?"
    static let URL_CONTACTS_SELECT = "\(URL_DB_SERVER)/PHPDatabaseCalls/contacts/select.php?"
    static let URL_CONTACTS_UPDATE = "\(URL_DB_SERVER)/PHPDatabaseCalls/contacts/update.php?"
    
    static let URL_DOCTORS_DELETE = "\(URL_DB_SERVER)/PHPDatabaseCalls/doctors/delete.php?"
    static let URL_DOCTORS_INSERT = "\(URL_DB_SERVER)/PHPDatabaseCalls/doctors/insert.php?"
    static let URL_DOCTORS_SELECT = "\(URL_DB_SERVER)/PHPDatabaseCalls/doctors/select.php?"
    static let URL_DOCTORS_UPDATE = "\(URL_DB_SERVER)/PHPDatabaseCalls/doctors/update.php?"
    
    static let URL_NOTIFICATIONS_GET_ALL_CALLS_ON = "\(URL_DB_SERVER)/PHPDatabaseCalls/notifications/getAllCallsOn.php?"
    static let URL_NOTIFICATIONS_GET_ALL_TEXTS_ON = "\(URL_DB_SERVER)/PHPDatabaseCalls/notifications/getAllTextsOn.php?"
    static let URL_NOTIFICATIONS_SELECT = "\(URL_DB_SERVER)/PHPDatabaseCalls/notifications/select.php?"
    static let URL_NOTIFICATIONS_UPDATE = "\(URL_DB_SERVER)/PHPDatabaseCalls/notifications/update.php?"
    
    static let URL_PATIENTS_SELECT = "\(URL_DB_SERVER)/PHPDatabaseCalls/patients/select.php?"
    static let URL_PATIENTS_UPDATE = "\(URL_DB_SERVER)/PHPDatabaseCalls/patients/update.php?"

    
    // Base URLs for Twilio API:
    private static let URL_TWILIO_SERVER = "http://dukecs408-twilio.herokuapp.com"
    static let URL_TWILIO_CALLS = "\(URL_TWILIO_SERVER)/notifyWithCall?"
    static let URL_TWILIO_TEXTS = "\(URL_TWILIO_SERVER)/notifyWithText?"
    
    
    // This is an abridged list of types that can be read. Full list is here: https://developer.apple.com/library/ios/documentation/HealthKit/Reference/HealthKit_Constants/index.html#//apple_ref/doc/constant_group/Body_Measurements
    static func getTypesToReadSet() -> NSSet {
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

    
    // The typeToUnitMap maps a health kit type identifier to a unit, such as pounds or ounces
    // Note: the unit needs to come from the list of health kit units which can be found here:
    // https://developer.apple.com/library/ios/documentation/HealthKit/Reference/HKUnit_Class/index.html#//apple_ref/doc/uid/TP40014727-CH1-SW2
    private static var typeToUnitMap : [String : String]! = nil
    static func getTypeToUnitMap() -> [String : String] {
        if (Constants.typeToUnitMap == nil) {
            Constants.typeToUnitMap = [
                HKQuantityTypeIdentifierBodyMass : "lb",
                HKQuantityTypeIdentifierStepCount : "count",
                HKQuantityTypeIdentifierHeartRate : "count/min",
                HKQuantityTypeIdentifierOxygenSaturation : "%"
            ]
        }
        return Constants.typeToUnitMap
    }
    
    
    // The typeIdToCommonNameMap maps a health kit type identifier to the common name of a statistic
    // For example, it maps "HKQuantityTypeIdentifierHeartRate" to simple "heart rate"
    // The purpose is to report type names that users will easily understand.
    private static var typeIdToCommonNameMap : [String : String]! = nil
    static func getTypeIdToCommonNameMap() -> [String : String] {
        if (Constants.typeIdToCommonNameMap == nil) {
            Constants.typeIdToCommonNameMap = [
                HKQuantityTypeIdentifierBodyMass : "body mass",
                HKQuantityTypeIdentifierStepCount : "step count",
                HKQuantityTypeIdentifierHeartRate : "heart rate",
                HKQuantityTypeIdentifierOxygenSaturation : "oxygen saturation"
            ]
        }
        return Constants.typeIdToCommonNameMap
    }
    
    
    // The typeIdToStatIdMap maps a health kit type identifier to the ID of a statistic in our database
    // ***IMPORTANT***: These values are hard coded and must be updated if the database changes
    private static var typeIdToStatIdMap : [String : String]! = nil
    static func getTypeIdToStatIdMap() -> [String : String] {
        if (Constants.typeIdToStatIdMap == nil) {
            Constants.typeIdToStatIdMap = [
                HKQuantityTypeIdentifierBodyMass : "1",
                HKQuantityTypeIdentifierStepCount : "7",
                HKQuantityTypeIdentifierHeartRate : "9",
                HKQuantityTypeIdentifierOxygenSaturation : "6"
            ]
        }
        return Constants.typeIdToStatIdMap
    }
}