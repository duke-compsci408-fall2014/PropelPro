//
//  Doctor.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/3/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation

class Doctor {
    var doctorId : String
    var doctorName : String
    var doctorPhoneNumber : String
    var doctorAddress : String
    
    init(id: String, name : String, number : String, address : String) {
        self.doctorId = id
        self.doctorName = name;
        self.doctorPhoneNumber = number;
        self.doctorAddress = address;
    }
    
    func toString() -> String {
        return "\(self.doctorId): \(self.doctorName)"
    }
}