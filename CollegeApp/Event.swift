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
    var imageURL: URL?
    var title: String?
    var link: URL?
    var dateString: String?
    var startDate: Date?
    var location: String?
    var description: String?
    
    var delegate: EventDelegate?
    
    func loadImage()
    {
        if image == nil && imageURL != nil
        {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
            {
                if let imageData = try? Data(contentsOf: self.imageURL!), let image = UIImage(data: imageData)
                {
                    DispatchQueue.main.async
                    {
                        self.image = image
                        self.delegate?.didLoadImage()
                    }
                }
                
                else
                {
                    DispatchQueue.main.async
                    {
                        self.image = nil
                        self.delegate?.didLoadImage()
                    }
                }
            }
        }
    }
}

protocol EventDelegate
{
    func didLoadImage()
}
