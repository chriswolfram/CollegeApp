//
//  DirectoryViewCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/16/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class DirectoryViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func showDirectoryEntry(entry: DirectoryEntry)
    {
        self.nameLabel.text = entry.name
        self.titleLabel.text = entry.title
    }
}