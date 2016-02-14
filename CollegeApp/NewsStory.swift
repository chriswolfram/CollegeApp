//
//  NewsStory.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class NewsStory
{
    var image: UIImage?
    var imageURL: NSURL?
    var title: String?
    var description: String?
    var link: NSURL?
    
    func loadImage(callback: ()->Void)
    {
        if image == nil && imageURL != nil
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                if let imageData = NSData(contentsOfURL: self.imageURL!), let image = UIImage(data: imageData)
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.image = image
                        callback()
                    }
                }
                    
                else
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.image = nil
                        callback()
                    }
                }
            }
        }
    }
}