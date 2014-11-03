//
//  JSONArray.swift
//  Hospital Tabbed App
//
//  Created by Chinmay Patwardhan on 11/3/14.
//  Copyright (c) 2014 Chinmay Patwardhan. All rights reserved.
//

import Foundation

/*
Note: input string is an array of shallow json objects like this:
[{ "abc":"1", "def":"akshay"}, { "abc":"2", "def":"brett"}]
Also note: all keys and values are surrounded by double quotes as above
Note: this assumes there are no curly brackets in the keys/values
*/

class JSONArray {
    var objects : [JSON]
    
    init(var str : NSString) {
        objects = []
        if (str.length > 2) {
            str = str.substringFromIndex(1) // chop off start bracket [
            str = str.substringToIndex(str.length - 1) // chop of end bracket]
            
            while (str.length > 2) {
                var startBracket = StringHelper.indexOf(str, c: "{", iteration: 1)
                var endBracket = StringHelper.indexOf(str, c: "}", iteration: 1)
                var jsonStr = str.substringToIndex(endBracket + 1) as NSString // include the bracket
                jsonStr = jsonStr.substringFromIndex(startBracket)
                objects.append(JSON(str: jsonStr))
                
                str = str.substringFromIndex(endBracket + 1) as NSString
            }
        }
    }
    
    func getObjects() -> [JSON] {
        return objects;
    }
}
