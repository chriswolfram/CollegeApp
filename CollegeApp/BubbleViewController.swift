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
    
    let bubbleRadius: CGFloat = 50
    
    let timeStep: NSTimeInterval = 1/60
    //Gravitational constant, IRL 0.0000000000667
    let G: CGFloat = 10000
    //Coefficient of Restitution
    let cr: CGFloat = 1
    //Spring Coefficient
    let k: CGFloat = 1
    
    var bodies = [GravitationalBody]()
    
    var timer: NSTimer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Setup scroll view
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 750, height: 750)
        
        //For testing
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        
        //Update landmark data and add bubbles asynchronously
        School.refreshToursIfNeeded
        {
            s in
            
            dispatch_async(dispatch_get_main_queue())
            {
                //If sucessfully got tour data
                if s
                {
                    School.tourLandmarks.forEach({self.addBubble($0)})
                }
                    
                    //If could not get tour data
                else
                {
                    let alertController = UIAlertController(title: "Could not load gallery.", message: "Could not connect to gallery server.  Make sure you are connected to the internet and try again in a few minutes.", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {_ in self.navigationController?.popToRootViewControllerAnimated(true)}))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
        
        //Add point mass in the center
        bodies.append(PointMass(center: CGPoint(x: scrollView.contentSize.width/2, y: scrollView.contentSize.height/2), mass: 3))
        
        timer = NSTimer.scheduledTimerWithTimeInterval(self.timeStep, target: self, selector: #selector(BubbleViewController.simulationStep), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width/2 - scrollView.frame.width/2, y: scrollView.contentSize.height/2 - scrollView.frame.height/2)
        
        if timer != nil
        {
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        timer?.invalidate()
        timer = nil
    }
    
    func addBubble(landmark: TourLandmark)
    {
        landmark.getThumbnail
        {
            image in
            
            if image != nil
            {
                let radius = self.bubbleRadius//100*CGFloat(arc4random())/CGFloat(UINT32_MAX)
                let bubbleView = BubbleView(position: CGPoint(x: (self.scrollView.contentSize.width-radius) * CGFloat(arc4random())/CGFloat(UINT32_MAX), y: (self.scrollView.contentSize.height-radius) * CGFloat(arc4random())/CGFloat(UINT32_MAX)), radius: radius)

                bubbleView.backgroundImageView.image = image!
                
                bubbleView.pressSelector =
                {
                    /*let viewController = TourViewDetailController.controllerForLandmark(landmark)
                    viewController.scrollViewOffset = 8
                    
                    let closeButton = UIButton()
                    closeButton.titleLabel?.text = "Close"
                    
                    viewController.loadView()
                    
                    viewController.view.addSubview(closeButton)
                    closeButton.bottomAnchor.constraintEqualToAnchor(viewController.contentView.topAnchor, constant: 8).active = true
                    closeButton.leftAnchor.constraintEqualToAnchor(viewController.contentView.leftAnchor).active = true
                    closeButton.widthAnchor.constraintEqualToConstant(50).active = true
                    closeButton.heightAnchor.constraintEqualToConstant(50).active = true
                    
                    viewController.modalTransitionStyle = .CoverVertical
                    viewController.modalPresentationStyle = .OverCurrentContext
                    viewController.modalInPopover = true
                    
                    self.navigationController?.presentViewController(viewController, animated: true, completion: nil)*/
                }
                
                self.scrollView.addSubview(bubbleView)
                
                self.bodies.append(bubbleView)
            }
        }
    }
    
    func simulationStep()
    {
        //print(NSUUID())
        bodies.enumerate().forEach
        {
            (index, b1) in
            
            //Interbody interactions
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
            
            //Wall interactions
            let leftDistance = b1.center.x - b1.radius - b1.bufferRadius
            let rightDistance = b1.center.x + b1.radius + b1.bufferRadius - scrollView.contentSize.width
            let topDistance = b1.center.y - b1.radius - b1.bufferRadius
            let bottomDistance = b1.center.y + b1.radius + b1.bufferRadius - scrollView.contentSize.height
            
            let xForce = -k*(min(0, leftDistance) + max(0, rightDistance))
            let yForce = -k*(min(0, topDistance) + max(0, bottomDistance))
            
            b1.force.x += xForce
            b1.force.y += yForce
        }
        
        bodies.forEach({$0.applyForce(timeStep)})
    }
}