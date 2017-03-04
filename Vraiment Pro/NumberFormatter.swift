//
//  NumberFormatter.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 19/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import Foundation

public class NumberFormatter{
    
    class func format(_ number:String, withSpace:Bool = false) -> String{
        var data = number.replacingOccurrences(of: " ", with: "")
        data = "".appending(  (data.components(separatedBy: NSCharacterSet.decimalDigits.inverted)).joined()  )
        
        var chars = data.characters
        data = "@\(data)"
        print(data, chars.count)
        if(chars.count > 10){
            if(data.contains("@0033")){
                data = data.replacingOccurrences(of: "@0033", with: "0")
            }
            else if(data.contains("@33")){
                data = data.replacingOccurrences(of: "@33", with: "0")
            }
        }
        data = data.replacingOccurrences(of: "@", with: "")
        
        if withSpace{
            var count = 0
            chars = data.characters
            data = ""
            for char in chars{
                if count % 2 == 0 && count != 0{
                    data += " "
                }
                data += "\(char)"
                count += 1
            }
        }
        //print(data)
        
        return data
    }
    
    class func format(_ number:String, withPrefix:String) -> String{
        var data = "@\(number)"
        data = data.replacingOccurrences(of: "@0", with: withPrefix)
        
        return data
        
    }
    
}
