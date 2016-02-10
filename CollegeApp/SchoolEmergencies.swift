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
        EmergencyContact(title: "Emergency", number: "911", formattedNumber: "911", smsEnabled: true),
        EmergencyContact(title: "Stanford Emergency Information Line", number: "1-650-725-5555", formattedNumber: "+1 650-725-5555"),
        EmergencyContact(title: "Non-Emergencies", number: "1-650-329-2413", formattedNumber: "+1 650-329-2413", smsEnabled: true),
        EmergencyContact(title: "CAPS Hotline", number: "1-650-723-3785", formattedNumber: "+1 650-723-3785", description: "For immediate mental health crisis assistance contact a CAPS on-call clinician any time, including evenings and weekends.  After hours calls are forwarded to our answering service provider who will page the CAPS on-call clinician.  A clinician will speak with you within 20 minutes of your call.  The on-call clinician will assess your situation and offer recommendations for follow-up."),
        EmergencyContact(title: "Bridge Peer Counseling", number: "1-650-723-3392", formattedNumber: "+1 650-723-3392"),
        EmergencyContact(title: "SARA Office", number: "1-650-725-9129", formattedNumber: "+1 650-725-9129"),
        EmergencyContact(title: "SARA 24hr Hotline", number: "1-650-725-9955", formattedNumber: "+1 650-725-9955"),
        
        EmergencyContact(title: "Christopher's phone", number: "1-617-459-1213", formattedNumber: "+1 617-459-1213", smsEnabled: true, description: "this is just a test")
    ]
}

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