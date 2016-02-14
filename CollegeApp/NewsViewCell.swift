//
//  NewsViewCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/20/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell, NewsStoryDelegate
{
    @IBOutlet var thumbnailView: UIImageView?
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    private var internalNewsStory: NewsStory?
    var newsStory: NewsStory?
    {
        get
        {
            return internalNewsStory
        }
        
        set(newNewsStory)
        {
            internalNewsStory = newNewsStory
            
            if newNewsStory != nil
            {
                titleLabel.text = newNewsStory!.title
                descriptionLabel.text = newNewsStory!.description
                showThumbnail(newNewsStory!.image)
                
                newNewsStory?.delegate = self
            }
        }
    }
    
    private func showThumbnail(image: UIImage?)
    {
        if image == nil
        {
            thumbnailView?.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        }
            
        else
        {
            thumbnailView?.image = image
            thumbnailView?.backgroundColor = UIColor.clearColor()
        }
    }
    
    func didLoadImage()
    {
        showThumbnail(newsStory?.image)
    }
}