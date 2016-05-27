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
    var landmarks: [TourLandmark]
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
            if let url = self.imageURL
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                {
                    if let imageData = NSData(contentsOfURL: url), let image = UIImage(data: imageData)
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
        }
            
        else
        {
            callback?(self.image)
        }
    }
    
    func reorder(callback: (Bool->Void)?)
    {
        let baseURL = NSURL(string: "https://www.wolframcloud.com/objects/c8932431-e51e-4446-a7bf-deee91a80ce5")!
        
        //Create the JSON to send
        let sendingJson = landmarks.map({["lat": $0.coordinate.latitude, "long": $0.coordinate.longitude]})
        if
            let sendingJsonData = try? NSJSONSerialization.dataWithJSONObject(sendingJson, options: .PrettyPrinted),
            let sendingJsonString = NSString(data: sendingJsonData, encoding: NSUTF8StringEncoding) as String?
        {
            //Send the JSON
            let request = NSMutableURLRequest(URL: baseURL)
            request.HTTPMethod = "POST"
            request.HTTPBody = ("json="+sendingJsonString).dataUsingEncoding(NSUTF8StringEncoding)
            
            NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                jsonData,_,_ in
                
                if jsonData != nil
                {
                    if
                        let json = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? [Int],
                        let ordering = json
                    {
                        dispatch_async(dispatch_get_main_queue())
                        {
                            self.landmarks = ordering.flatMap({self.landmarks[$0]})

                            callback?(true)
                        }
                    }
                    
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), {callback?(false)})
                    }
                }
                
                else
                {
                    dispatch_async(dispatch_get_main_queue(), {callback?(false)})
                }
                
            }.resume()
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), {callback?(false)})
        }
    }
}