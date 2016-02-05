//
//  EmergencyViewCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/23/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class EmergencyViewCell: UITableViewCell
{
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    func showEmergencyContact(contact: EmergencyContact)
    {
        self.titleLabel.text = contact.title
        self.numberLabel.text = contact.formattedNumber
    }
}