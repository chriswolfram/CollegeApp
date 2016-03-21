//
//  FyuseViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/26/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import CoreMotion

class FyuseViewController
{
    var imageView: UIImageView!
    var images: [UIImage?]!
    
    var currentFrame = 0
    var maxFrame = 0
    
    let motionManager = CMMotionManager()//MotionManager.sharedInstance
    
    init()
    {
        if imageView == nil
        {
            imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if motionManager.gyroAvailable
        {
            motionManager.gyroUpdateInterval = 1/30
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue())
            {
                [weak self] (gyroHandler, _) in
                
                if self == nil
                {
                    return
                }
                
                if let gyro = gyroHandler
                {
                    let newFrame = self!.currentFrame + Int(gyro.rotationRate.y*5)
                        
                    if newFrame != self!.currentFrame && newFrame >= 0 && newFrame <= self!.maxFrame
                    {
                        self!.currentFrame = newFrame
                        
                        if let newImage = self!.images[self!.currentFrame]
                        {
                            self!.imageView.image = newImage
                        }
                    }
                }
            }
        }
    }
    
    convenience init(imageView: UIImageView)
    {
        self.init()
        
        self.imageView = imageView
    }
    
    func showFyuse(fyuseIdentifier: String, sizeSetCallback: CGSize -> Void = {$0})
    {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "http://fyu.se/embed/"+fyuseIdentifier)!)
        {
            (jsonData, _, _) in
            
            let json = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let basePath = json["path"] as! String
            self.maxFrame = (json["fy"]!["l"] as! NSArray)[1] as! Int
            
            self.images = [UIImage?](count: self.maxFrame+1, repeatedValue: nil)
            
            (0...self.maxFrame).forEach
            {
                frame in
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: basePath+"frames_\(frame).jpg")!)
                {
                    (imageData, _, _) in
                    
                    print(fyuseIdentifier)
                    print(frame)
                    
                    if imageData != nil, let image = UIImage(data: imageData!)
                    {
                        dispatch_async(dispatch_get_main_queue())
                        {
                            self.images[frame] = image
                            if self.imageView.image == nil
                            {
                                let image = self.images[frame]
                                
                                self.imageView.image = image
                                self.imageView.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .Width, relatedBy: .Equal, toItem: self.imageView, attribute: .Height, multiplier: image!.size.width/image!.size.height, constant: 0))
                                
                                sizeSetCallback(image!.size)
                            }
                        }
                    }
                }.resume()
            }
        }.resume()
    }
}

/*struct MotionManager
{
    static let sharedInstance = CMMotionManager()
}*/