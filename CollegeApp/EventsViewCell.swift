//
//  EventsViewCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/3/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class EventsViewCell: UITableViewCell, EventDelegate
{
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var internalEvent: Event?
    var event: Event?
    {
        get
        {
            return internalEvent
        }
        
        set(newEvent)
        {
            internalEvent = newEvent
            
            if newEvent != nil
            {
                titleLabel.text = newEvent!.title
                locationLabel.text = newEvent!.location
                dateLabel.text = newEvent!.dateString
                thumbnailView.image = newEvent!.image
                
                newEvent?.delegate = self
            }
        }
    }
    
    func didLoadImage()
    {
        self.thumbnailView.image = self.event?.image
    }
    
    func loadThumbnail()
    {
        self.event?.loadImage()
    }
}