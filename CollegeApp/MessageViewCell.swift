//
//  MessageViewCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/20/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func showMessage(message: Message)
    {
        self.nameLabel.text = message.fromDisplay
        self.bodyLabel.text = message.body
    }
}