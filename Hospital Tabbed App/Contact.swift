//
//  Contact.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/5/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation

class Contact {
    var contactId : String
    var contactName : String
    var contactPhoneNumber : String

    var stepsTuple = (statId:7, isText: false, isCall: false)
    var bodyMassTuple = (statId:1, isText: false, isCall: false)
    var oxyTuple = (statId:6, isText: false, isCall: false)
    var hrTuple = (statId:9, isText: false, isCall: false)

    init(id: String, name : String, number : String) {
        self.contactId = id
        self.contactName = name;
        self.contactPhoneNumber = number;
    }
    
    func toString() -> String {
        return "\(self.contactName): \(self.contactPhoneNumber)"
    }
}