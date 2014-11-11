//
//  JSON.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/3/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation

/*
Note: input string is a shallow json representation like this:
{ "abc":"12","def": "7031234567"}
Also note: all keys and values are surrounded by double quotes
*/

class JSON {
    var map : [String: String];
    
    init(var str: NSString) {
        self.map = Dictionary<String, String>()
        str = str.substringFromIndex(1)
        str = str.substringToIndex(str.length - 1)
        
        while (str.length > 0) {
            var key : NSString;
            var value : NSString;
            
            // find key
            var firstQuote = StringHelper.indexOf(str, c:"\"", iteration:1)
            var secondQuote = StringHelper.indexOf(str, c:"\"", iteration:2)
            key = str.substringToIndex(secondQuote)
            key = key.substringFromIndex(firstQuote+1)
            str = str.substringFromIndex(secondQuote+1)
            
            // find value
            firstQuote = StringHelper.indexOf(str, c:"\"", iteration:1)
            secondQuote = StringHelper.indexOf(str, c:"\"", iteration:2)
            value = str.substringToIndex(secondQuote)
            value = value.substringFromIndex(firstQuote+1)
            str = str.substringFromIndex(secondQuote+1)
            
            map[key] = value
            
            if !str.containsString("\"") {
                break;
            }
        }
        println("the map:")
        println(map)
    }
    
    func getMap() -> [String : String] {
        return map;
    }
}