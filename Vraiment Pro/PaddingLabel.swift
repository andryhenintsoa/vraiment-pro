//
//  PaddingLabel.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 07/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override open var intrinsicContentSize: CGSize{
        
        var superContentSize = super.intrinsicContentSize
        superContentSize.width += padding.left + padding.right
        superContentSize.height += padding.top + padding.bottom
        
        return superContentSize
    }
    
}
