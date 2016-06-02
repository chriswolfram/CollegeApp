//
//  BubbleViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 3/7/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class BubbleViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    
    let timeStep: NSTimeInterval = 1/60
    //Gravitational constant, IRL 0.0000000000667
    let G: CGFloat = 10000
    //Coefficient of Restitution
    let cr: CGFloat = 1
    //Spring Coefficient
    let k: CGFloat = 1
    
    var bodies = [GravitationalBody]()
    
    let bubbleRadius: CGFloat = 50
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Setup scroll view
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        
        //For testing
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        
        //Update landmark data and add bubbles asynchronously
        School.refreshTours
        {
            School.tourLandmarks.forEach
            {
                self.addBubble($0)
            }
        }
        
        //Add point mass in the center
        bodies.append(PointMass(center: CGPoint(x: scrollView.contentSize.width/2, y: scrollView.contentSize.height/2), mass: 3))
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(self.timeStep, target: self, selector: #selector(BubbleViewController.simulationStep), userInfo: nil, repeats: true)
        
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width/2 - scrollView.frame.width/2, y: scrollView.contentSize.height/2 - scrollView.frame.height/2)
    }
    
    func addBubble(landmark: TourLandmark)
    {
        landmark.getImage
        {
            image in
            
            if image != nil
            {
                let radius = self.bubbleRadius//100*CGFloat(arc4random())/CGFloat(UINT32_MAX)
                let bubbleView = BubbleView(position: CGPoint(x: (self.scrollView.contentSize.width-radius) * CGFloat(arc4random())/CGFloat(UINT32_MAX), y: (self.scrollView.contentSize.height-radius) * CGFloat(arc4random())/CGFloat(UINT32_MAX)), radius: radius)

                bubbleView.backgroundImageView.image = image!
                
                bubbleView.pressSelector =
                {
                    //Add code here to show the detail view
                    print("pressed")
                }
                
                self.scrollView.addSubview(bubbleView)
                
                self.bodies.append(bubbleView)
            }
        }
    }
    
    func simulationStep()
    {
        bodies.enumerate().forEach
        {
            (index, b1) in
            
            bodies.dropFirst(index+1).forEach
            {
                b2 in
                
                //a==G*m2/d^2
                
                let d = hypot(b1.center.x - b2.center.x, b1.center.y - b2.center.y)
                
                if d > b1.radius + b1.bufferRadius + b2.radius + b2.bufferRadius
                {
                    let gmmd3 = G * b1.mass * b2.mass / (d*d*d)
                    
                    let xForce = gmmd3*(b2.center.x - b1.center.x)
                    let yForce = gmmd3*(b2.center.y - b1.center.y)
                    
                    b1.force.x += xForce
                    b1.force.y += yForce
                    b2.force.x -= xForce
                    b2.force.y -= yForce
                }
                
                else if b1.hookeLaw && b2.hookeLaw && d > b1.radius + b2.radius
                {
                    //Hooke's Law collisions
                    let xForce = -k*(b2.center.x - b1.center.x)/d
                    let yForce = -k*(b2.center.y - b1.center.y)/d
                    
                    b1.force.x += xForce
                    b1.force.y += yForce
                    b2.force.x -= xForce
                    b2.force.y -= yForce
                }
                
                else if b1.collisions && b2.collisions
                {
                    //Realistic collisions
                    let magnitude = cr * hypot(b1.velocity.x - b2.velocity.x, b1.velocity.y - b2.velocity.y)/2
                    let intersection = b1.radius + b2.radius - d
                    
                    let intersectionVector = CGPoint(x: ((b1.center.x - b2.center.x) / d)*(intersection/2), y: ((b1.center.y - b2.center.y) / d)*(intersection/2))
                    
                    b1.center.x += intersectionVector.x
                    b1.center.y += intersectionVector.y
                    b2.center.x -= intersectionVector.x
                    b2.center.y -= intersectionVector.y
                    
                    let velocityVector = CGPoint(x: ((b1.center.x - b2.center.x) / d) * magnitude, y: ((b1.center.y - b2.center.y) / d) * magnitude)
                    
                    b1.velocity.x += velocityVector.x
                    b1.velocity.y += velocityVector.y
                    b2.velocity.x -= velocityVector.x
                    b2.velocity.y -= velocityVector.y
                }
            }
        }
        
        bodies.forEach({$0.applyForce(timeStep)})
    }
}