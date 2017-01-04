//
//  UIFont+withTraits.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 22/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

extension UIFont{
    func withTraits(traits: UIFontDescriptorSymbolicTraits...) -> UIFont{
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont{
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont{
        return withTraits(traits: .traitItalic)
    }
}
