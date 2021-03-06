//
//  StringHelper.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/3/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation

class StringHelper {
    class func indexOf(str: String, c: Character, iteration: Int) -> Int {
        var ret : Int = 0
        var numFound : Int = 0
        var pos : Int = 0
        for char in str {
            if char == c {
                numFound++
            }
            if (numFound == iteration) {
                return pos;
            }
            pos++
        }
        return -1; // not found
    }
    
    // TODO: clean it up to comply with our JSON parsing assumptions
    class func cleanURLString(url : String) ->String {
            var out : String = "";
            for char in url {
                if char == " " {
                    out += "%20"
                } else {
                    out += "\(char)";
                }
            }
            return out
    }

}