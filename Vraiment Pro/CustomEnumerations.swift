//
//  File.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 14/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

enum SendingType:String {
    case sms = "SMS"
    case mail = "Mail"
}

enum JoiningBillOption:String {
    case now
    case later
}

enum SendingProfileType:String{
    case selfProfile = "Mon profil"
    case partnersProfile = "Profil(s) de partenaire"
}

enum DocsType:String{
    case samplePic
    case beforeAfterPic
    case doc
}
