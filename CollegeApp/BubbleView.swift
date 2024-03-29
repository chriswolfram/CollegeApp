//
//  BubbleView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 3/8/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class BubbleView: UIButton, GravitationalBody
{
    var mass: CGFloat = 1
    var radius: CGFloat = 50//Just a default
    var bufferRadius: CGFloat = 10//just a default
    let maxVelocity: CGFloat = 10000
    var velocity = CGPoint(x: 0, y: 0)
    var force = CGPoint(x: 0, y: 0)
    
    let collisions = true
    let hookeLaw = true
    
    var backgroundImageView: UIImageView = UIImageView()
    var pressSelector: ((Void)->Void)?
    
    var image: UIImage?
    {
        didSet
        {
            backgroundImageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        print("Coder not fully supported in BubbleView.swift")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.isExclusiveTouch = true
        
        self.addTarget(self, action: #selector(BubbleView.pressed), for: .touchUpInside)
        
        //Setup image view
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //Next line may be unnecesarrily complicated
        //backgroundImageView.bounds = CGRect(x: -self.bounds.origin.x, y: -self.bounds.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        backgroundImageView.contentMode = .scaleAspectFill
        self.addSubview(backgroundImageView)
        
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    convenience init(position: CGPoint, radius: CGFloat)
    {
        self.init(frame: CGRect(origin: position, size: CGSize(width: Double(radius*2), height: Double(radius*2))))
        self.radius = radius
    }
    
    override func draw(_ rect: CGRect)
    {
        self.layer.cornerRadius = self.frame.width/2
        
        super.draw(rect)
    }
    
    func pressed()
    {
        pressSelector?()
    }
    
    func applyForce(_ timeStep: TimeInterval)
    {
        velocity.x += force.x / mass
        velocity.y += force.y / mass
                
        force.x = 0
        force.y = 0
        
        let velocityMagnitude = hypot(velocity.x, velocity.y)
        if velocityMagnitude > maxVelocity
        {
            velocity.x *= maxVelocity/velocityMagnitude
            velocity.y *= maxVelocity/velocityMagnitude
        }
        
        //dispatch_async(dispatch_get_main_queue())
        //{
            self.center.x += self.velocity.x * CGFloat(timeStep)
            self.center.y += self.velocity.y * CGFloat(timeStep)
        //}
    }
}
