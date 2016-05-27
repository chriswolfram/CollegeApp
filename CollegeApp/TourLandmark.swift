//
//  TourLandmark.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import CoreLocation
import UIKit
import AVFoundation

class TourLandmark: Hashable
{
    var coordinate: CLLocationCoordinate2D!
    var titleString: String?
    var textString: String?
    var imageURL: NSURL?
    var image: UIImage?
    var audioURL: NSURL?
    var audioPlayer: AVAudioPlayer?
    var videoURL: NSURL?
    
    init?(xmlElement: XMLElement)
    {
        if
            let latString = xmlElement["latitude"]?.contents,
            let lat = Double(latString),
            let longString = xmlElement["longitude"]?.contents,
            let long = Double(longString)
        {
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            titleString = xmlElement["title"]?.contents
            textString = xmlElement["text"]?.contents
            
            if let urlString = xmlElement["imageURL"]?.contents
            {
                imageURL = NSURL(string: urlString)
            }
            
            if let urlString = xmlElement["audioURL"]?.contents
            {
                audioURL = NSURL(string: urlString)
            }
            
            if let urlString = xmlElement["videoURL"]?.contents
            {
                videoURL = NSURL(string: urlString)
            }
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
                            callback?(self.image)
                        }
                    }
                
                    self.imageLoaded = true
                }
            }
        }
        
        else
        {
            callback?(self.image)
        }
    }
    
    private var audioPlayerLoaded = false
    func getAudioPlayer(callback: (AVAudioPlayer?->Void)? = nil)
    {
        if !audioPlayerLoaded
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                if let audioData = NSData(contentsOfURL: self.audioURL!), let audioPlayer = try? AVAudioPlayer(data: audioData) where self.audioURL != nil
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.audioPlayer = audioPlayer
                        callback?(self.audioPlayer)
                    }
                }
                
                self.audioPlayerLoaded = true
            }
        }
            
        else
        {
            callback?(self.audioPlayer)
        }
    }
    
    var hashValue: Int
    {
        return "\(coordinate)\(titleString)\(textString)".hashValue
    }
}

func ==(lhs: TourLandmark, rhs: TourLandmark) -> Bool
{
    return lhs.hashValue == rhs.hashValue
}