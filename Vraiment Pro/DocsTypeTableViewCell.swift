//
//  DocsTypeTableViewCell.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 07/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class DocsTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var content: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if (selected) {
            self.content.textColor =  UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1)
        } else {
            self.content.textColor = UIColor.black
        }
    }
}
