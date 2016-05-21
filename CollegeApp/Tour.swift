//
//  Tour.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class Tour
{
    let title: String?
    let landmarks: [TourLandmark]
    var currentIndex = 0
    
    var imageURL: NSURL?
    var image: UIImage?
    
    var currentLandmark: TourLandmark
    {
        get
        {
            return landmarks[currentIndex]
        }
    }
    
    init(landmarks: [TourLandmark], title: String? = nil, startIndex: Int = 0)
    {
        self.landmarks = landmarks
        self.title = title
        self.currentIndex = startIndex
    }
    
    init?(xmlElement: XMLElement, landmarks: [TourLandmark])
    {
        let tourLandmarks = xmlElement["landmarkIndices"]?["index", .All]?.flatMap
        {
            (indexXML: XMLElement) -> TourLandmark? in
            
            if
                let indexString = indexXML.contents,
                let index = Int(indexString)
                where 0 <= index && index < landmarks.count
            {
                return landmarks[index]
            }
            
            return nil
        }
        
        if tourLandmarks != nil
        {
            self.landmarks = tourLandmarks!
            self.title = xmlElement["title"]?.contents
            self.currentIndex = 0
            
            if let urlString = xmlElement["image"]?.contents
            {
                self.imageURL = NSURL(string: urlString)
            }
        }
        
        else
        {
            return nil
        }
    }
    
    private var imageLoaded = false
    func getImage(callback: (UIImage?->Void)? = nil)
    {
        if !imageLoaded
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                if let imageData = NSData(contentsOfURL: self.imageURL!), let image = UIImage(data: imageData)
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.image = image
                        self.imageLoaded = true
                        callback?(self.image)
                    }
                }
            }
        }
            
        else
        {
            callback?(self.image)
        }
    }
}