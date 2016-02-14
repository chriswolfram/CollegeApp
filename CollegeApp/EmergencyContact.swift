//
//  EmergencyContact.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation

class EmergencyContact
{
    let title: String
    let number: String
    let formattedNumber: String
    let smsEnabled: Bool
    let description: String?
    
    init(title: String, number: String, formattedNumber: String, smsEnabled: Bool = false, description: String? = nil)
    {
        self.title = title
        self.number = number
        self.formattedNumber = formattedNumber
        self.description = description
        self.smsEnabled = smsEnabled
    }
}