//
//  Event.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class Event
{
    var image: UIImage?
    var imageURL: NSURL?
    var title: String?
    var link: NSURL?
    var dateString: String?
    var startDate: NSDate?
    var location: String?
    var description: String?
    
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