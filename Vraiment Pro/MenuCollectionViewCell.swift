//
//  MenuCollectionViewCell.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 06/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var notificationContainer: UIView!
    
    func displayNotification(_ status:Bool=true){
        notificationContainer.alpha = (status) ? 1 : 0
    }
}
