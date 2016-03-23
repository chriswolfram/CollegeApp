//
//  BubbleView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 3/8/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class BubbleView: UIButton
{
    var initialRadius: Float!
    var radius: Float!
    var initialPosition: CGPoint!
    var offset = CGPoint(x: 0, y: 0)
    
    var image: UIImage?
    
    var pressSelector: (Void->Void)?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        self.exclusiveTouch = true
        
        self.addTarget(self, action: #selector(BubbleView.pressed), forControlEvents: .TouchUpInside)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.exclusiveTouch = true
        
        self.addTarget(self, action: #selector(BubbleView.pressed), forControlEvents: .TouchUpInside)
    }
    
    convenience init(position: CGPoint, radius: Float)
    {
        self.init(frame: CGRect(origin: position, size: CGSize(width: Double(radius*2), height: Double(radius*2))))
        self.initialRadius = radius
        self.radius = radius
        self.initialPosition = position
    }
    
    convenience init(position: CGPoint, radius: Float, image: UIImage)
    {
        self.init(frame: CGRect(origin: position, size: CGSize(width: Double(radius*2), height: Double(radius*2))))
        self.initialRadius = radius
        self.radius = radius
        self.initialPosition = position
        
        self.image = image
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.bounds = CGRect(x: -self.bounds.origin.x, y: -self.bounds.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        imageView.contentMode = .ScaleToFill
        self.addSubview(imageView)
        
        imageView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        imageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        imageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        imageView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
    }
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        self.frame.size.width = CGFloat(radius*2)
        self.frame.size.height = CGFloat(radius*2)
        self.frame.origin.x = initialPosition.x - CGFloat(radius) + offset.x
        self.frame.origin.y = initialPosition.y - CGFloat(radius) + offset.y
        
        self.layer.cornerRadius = CGFloat(radius)
    }
    
    func refreshSizeInView(superview: UIView)
    {
        var center = superview.convertPoint(CGPoint(x: 0, y: 0), fromView: self)
        center.x += CGFloat(radius)
        center.y += CGFloat(radius)
        
        let xDist = center.x - superview.frame.width/2
        let yDist = center.y - superview.frame.height/2
        let distance = Float(sqrt(xDist*xDist + yDist*yDist))
        
        let triggerDistance = initialRadius*3
        if distance > triggerDistance
        {
            //radius = 25 * initialRadius/(distance - triggerDistance)
            radius = 3 * initialRadius/sqrt(distance - triggerDistance)
        }
        
        else
        {
            radius = initialRadius
        }
        
        if radius < 3
        {
            radius = 3
        }
        
        else if radius > initialRadius
        {
            radius = initialRadius
            offset.x = 0
            offset.y = 0
        }
        
        self.setNeedsDisplay()
    }
    
    func pressed()
    {
        pressSelector?()
    }
}