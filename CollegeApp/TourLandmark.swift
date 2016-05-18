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

class TourLandmark
{
    var coordinate: CLLocationCoordinate2D!
    var titleString: String?
    var textString: String?
    var imageURL: NSURL?
    var image: UIImage?
    var audioURL: NSURL?
    var videoURL: NSURL?
    
    private var internalAudioPlayer: AVPlayer?
    var audioPlayer: AVPlayer?
    {
        if internalAudioPlayer == nil && audioURL != nil
        {
            internalAudioPlayer = AVPlayer(URL: audioURL!)
        }
        
        return internalAudioPlayer
    }
    
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
    
    //var major: NSNumber?
    //var minor: NSNumber?
    
    /*init(coordinate: CLLocationCoordinate2D, title: String?, descriptionString: String?, thumbnailPath: String? = nil, beaconMajor: NSNumber? = nil, beaconMinor: NSNumber? = nil)
    {
        super.init(coordinate: coordinate, title: title)
        self.descriptionString = descriptionString
        self.thumbnailPath = thumbnailPath
        //self.major = beaconMajor
        //self.minor = beaconMinor
    }*/
    
    /*convenience init(_ landmark: Landmark, descriptionString: String? = nil, thumbnailPath: String? = nil)
    {
        self.init(coordinate: landmark.coordinate, title: landmark.title, descriptionString: descriptionString, thumbnailPath: thumbnailPath)
    }*/
}