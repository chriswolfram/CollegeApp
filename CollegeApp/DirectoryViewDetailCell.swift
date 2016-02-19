//
//  DirectoryViewDetailCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/19/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class DirectoryViewDetailCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var departmentLabel: UILabel?
    @IBOutlet weak var phoneLabel: UILabel?
    @IBOutlet weak var emailLabel: UILabel?
    
    func showDirectoryEntry(entry: DirectoryEntry)
    {
        self.nameLabel?.text = entry.name
        self.titleLabel?.text = entry.title
        self.departmentLabel?.text = entry.department
        self.phoneLabel?.text = entry.formattedPhoneNumber
        self.emailLabel?.text = entry.emailAddress
    }
}