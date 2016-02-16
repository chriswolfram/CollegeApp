//
//  DirectoryEntry.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/16/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation

class DirectoryEntry
{
    let name: String
    let title: String?
    let department: String?
    let phoneNumber: String?
    let formattedPhoneNumber: String?
    let emailAddress: String?
    
    init(name: String, title: String? = nil, department: String? = nil, phoneNumber: String? = nil, formattedPhoneNumber: String? = nil, emailAddress: String? = nil)
    {
        self.name = name
        self.department = department
        self.phoneNumber = phoneNumber
        self.formattedPhoneNumber = formattedPhoneNumber
        self.emailAddress = emailAddress
    }
}