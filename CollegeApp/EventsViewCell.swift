//
//  EventsViewCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/3/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class EventsViewCell: UITableViewCell
{
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func showEvent(event: Event)
    {
        titleLabel.text = event.title
        locationLabel.text = event.location
        dateLabel.text = event.dateString
        thumbnailView.image = event.image
    }
}