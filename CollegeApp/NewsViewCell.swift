//
//  NewsViewCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/20/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell
{
    @IBOutlet var thumbnailView: UIImageView?
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    func showNewsStory(story: NewsStory)
    {
        titleLabel.text = story.title
        descriptionLabel.text = story.description
        
        if story.image == nil
        {
            thumbnailView?.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        }
        
        else
        {
            thumbnailView?.image = story.image
            thumbnailView?.backgroundColor = UIColor.clearColor()
        }
    }
}