//
//  DirectoryViewDetailController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/16/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class DirectoryViewDetailController: UIViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    func showDirectoryEntry(entry: DirectoryEntry)
    {
        let _ = self.view
        
        self.nameLabel.text = entry.name
        self.titleLabel.text = entry.title
        self.departmentLabel.text = entry.department
        self.phoneNumberLabel.text = entry.formattedPhoneNumber
        self.emailAddressLabel.text = entry.emailAddress
    }
}