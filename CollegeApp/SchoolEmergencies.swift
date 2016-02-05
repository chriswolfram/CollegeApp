//
//  SchoolEmergencies.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/1/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation

extension School
{
    static let emergencyContacts =
    [
        EmergencyContact(title: "Emergency", number: "911", formattedNumber: "911"),
        EmergencyContact(title: "Anonymous Tip Line", number: "1-617-333-2159", formattedNumber: "+1 617-333-2159"),
        EmergencyContact(title: "Closing Hotline", number: "1-617-333-2075", formattedNumber: "+1 617-333-2075"),
        EmergencyContact(title: "Emergency Line", number: "1-617-333-2222", formattedNumber: "+1 617-333-2222"),
        EmergencyContact(title: "Health Center", number: "1-617-333-2182", formattedNumber: "+1 617-333-2182"),
    ]
}

class EmergencyContact
{
    let title: String
    let number: String
    let formattedNumber: String
    let description: String?
    
    init(title: String, number: String, formattedNumber: String, description: String? = nil)
    {
        self.title = title
        self.number = number
        self.formattedNumber = formattedNumber
        self.description = description
    }
}