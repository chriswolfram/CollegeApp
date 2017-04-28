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
    var imageURL: URL?
    var image: UIImage?
    var thumbnailURL: URL?
    var thumbnail: UIImage?
    var audioURL: URL?
    var audioPlayer: AVAudioPlayer?
    var videoURL: URL?
    
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
                imageURL = URL(string: urlString)
            }
            
            if let urlString = xmlElement["thumbnailURL"]?.contents
            {
                thumbnailURL = URL(string: urlString)
            }
            
            if let urlString = xmlElement["audioURL"]?.contents
            {
                audioURL = URL(string: urlString)
            }
            
            if let urlString = xmlElement["videoURL"]?.contents
            {
                videoURL = URL(string: urlString)
            }
        }
    }
    
    func getImage(_ callback: ((UIImage?)->Void)? = nil)
    {
        if image == nil
        {
            if let url = self.imageURL
            {
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
                {
                    if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData)
                    {                        
                        DispatchQueue.main.async
                        {
                            self.image = image
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
    
    func getThumbnail(_ callback: ((UIImage?)->Void)? = nil)
    {
        if thumbnail == nil
        {
            if let url = self.thumbnailURL
            {
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
                {
                    if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData)
                    {
                        DispatchQueue.main.async
                        {
                            self.thumbnail = image
                            callback?(self.thumbnail)
                        }
                    }
                }
            }
        }
            
        else
        {
            callback?(self.thumbnail)
        }
    }
    
    fileprivate var audioPlayerLoaded = false
    func getAudioPlayer(_ callback: ((AVAudioPlayer?)->Void)? = nil)
    {
        if !audioPlayerLoaded
        {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
            {
                if let audioData = try? Data(contentsOf: self.audioURL!), let audioPlayer = try? AVAudioPlayer(data: audioData), self.audioURL != nil
                {
                    DispatchQueue.main.async
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
