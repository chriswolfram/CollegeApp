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
        
        if motionManager.isGyroAvailable
        {
            motionManager.gyroUpdateInterval = 1/30
            motionManager.startGyroUpdates(to: OperationQueue.main)
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
    
    func showFyuse(_ fyuseIdentifier: String, sizeSetCallback: @escaping (CGSize) -> Void = {$0})
    {
        /*URLSession.shared.dataTask(with: URL(string: "http://fyu.se/embed/"+fyuseIdentifier)!, completionHandler: {
            (jsonData, _, _) in
            
            let json = try! JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            let basePath = json["path"] as! String
            self.maxFrame = (json["fy"]!["l"] as! NSArray)[1] as! Int
            
            self.images = [UIImage?](repeating: nil, count: self.maxFrame+1)
            
            (0...self.maxFrame).forEach
            {
                frame in
                
                URLSession.shared.dataTask(with: URL(string: basePath+"frames_\(frame).jpg")!, completionHandler: {
                    (imageData, _, _) in
                    
                    print(fyuseIdentifier)
                    print(frame)
                    
                    if imageData != nil, let image = UIImage(data: imageData!)
                    {
                        DispatchQueue.main.async
                        {
                            self.images[frame] = image
                            if self.imageView.image == nil
                            {
                                let image = self.images[frame]
                                
                                self.imageView.image = image
                                self.imageView.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: self.imageView, attribute: .height, multiplier: image!.size.width/image!.size.height, constant: 0))
                                
                                sizeSetCallback(image!.size)
                            }
                        }
                    }
                })                
.resume()
            }
        })        
.resume()*/
    }
}

/*struct MotionManager
{
    static let sharedInstance = CMMotionManager()
}*/
