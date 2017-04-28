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
        let tourLandmarks = xmlElement["landmarkIndices"]?["index", .all]?.flatMap
        {
            (indexXML: XMLElement) -> TourLandmark? in
            
            if
                let indexString = indexXML.contents,
                let index = Int(indexString), 0 <= index && index < landmarks.count
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
        }
        
        else
        {
            return nil
        }
    }
    
    func reorder(_ callback: ((Bool)->Void)?)
    {
        let baseURL = URL(string: "https://www.wolframcloud.com/objects/c8932431-e51e-4446-a7bf-deee91a80ce5")!
        
        //Create the JSON to send
        let sendingJson = landmarks.map({["lat": $0.coordinate.latitude, "long": $0.coordinate.longitude]})
        if
            let sendingJsonData = try? JSONSerialization.data(withJSONObject: sendingJson, options: .prettyPrinted),
            let sendingJsonString = NSString(data: sendingJsonData, encoding: String.Encoding.utf8.rawValue) as String?
        {
            //Send the JSON
            let request = NSMutableURLRequest(url: baseURL)
            request.httpMethod = "POST"
            request.httpBody = ("json="+sendingJsonString).data(using: String.Encoding.utf8)
            
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
                jsonData,_,_ in
                
                if jsonData != nil
                {
                    if
                        let json = try? JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Int],
                        let ordering = json
                    {
                        DispatchQueue.main.async
                        {
                            self.landmarks = ordering.flatMap({self.landmarks[$0]})

                            callback?(true)
                        }
                    }
                    
                    else
                    {
                        DispatchQueue.main.async(execute: {callback?(false)})
                    }
                }
                
                else
                {
                    DispatchQueue.main.async(execute: {callback?(false)})
                }
                
            })            
.resume()
        }
        
        else
        {
            DispatchQueue.main.async(execute: {callback?(false)})
        }
    }
}
