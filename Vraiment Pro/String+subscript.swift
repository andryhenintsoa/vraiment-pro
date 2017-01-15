//
//  String+subscript.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 15/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(startIndex, offsetBy: i)]
        
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: r.lowerBound)
        let end = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}

// TIPS
//"abcde"[0] == "a"
//"abcde"[0...2] == "abc"
//"abcde"[2..<4] == "cd"
