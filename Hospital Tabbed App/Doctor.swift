//
//  Doctor.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/3/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation

class Doctor {
    var doctorName : String
    var doctorPhoneNumber : String
    var doctorAddress : String
    
    init(name : String, number : String, address : String) {
        self.doctorName = name;
        self.doctorPhoneNumber = number;
        self.doctorAddress = address;
    }
}