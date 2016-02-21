//
//  HomescreenViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/5/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Social

class HomescreenViewController: UIViewController
{    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollBackgroundView: UIView!
    
    let avplayer = AVPlayer(URL:  NSBundle.mainBundle().URLForResource("homescreenBackground", withExtension: "mp4")!)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*effectView.addConstraints([
            NSLayoutConstraint(item: effectView, attribute: .Left, relatedBy: .Equal, toItem: scrollBackgroundView, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: effectView, attribute: .Right, relatedBy: .Equal, toItem: scrollBackgroundView, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: effectView, attribute: .Top, relatedBy: .Equal, toItem: scrollBackgroundView, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: effectView, attribute: .Bottom, relatedBy: .Equal, toItem: scrollBackgroundView, attribute: .Bottom, multiplier: 1, constant: 0)])*/
        
        //Set the background view to move with parallax
        /*let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 20
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
        
        backgroundImageView.addMotionEffect(group)*/
        
        let avplayerLayer = AVPlayerLayer(player: avplayer)
        avplayerLayer.frame = view.frame
        avplayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        avplayer.actionAtItemEnd = .None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishedVideo", name: AVPlayerItemDidPlayToEndTimeNotification, object: avplayer.currentItem)
        
        view.layer.addSublayer(avplayerLayer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "viewDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        avplayer.play()
    }
    
    func viewDidBecomeActive()
    {
        self.viewDidAppear(false)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        avplayer.play()
        
        School.newsStories = []
        School.events = []
        School.directoryEntries = []
        
        //Add blur background
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        effectView.frame = self.scrollBackgroundView.frame
        
        self.view.insertSubview(effectView, atIndex: 1)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        avplayer.pause()
    }
    
    func finishedVideo()
    {
        avplayer.seekToTime(CMTime(seconds: 0, preferredTimescale: 1))
        avplayer.play()
    }
    
    @IBAction func facebookButton(sender: UIButton)
    {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
        {
            let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeViewController.setInitialText(School.facebookShareDefaultMessage)
            
            self.presentViewController(composeViewController, animated: true, completion: nil)
        }
        
        else
        {
            let alert = UIAlertController(title: "Facebook Account", message: "Please login to a Facebook account in Settings to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func twitterButton(sender: UIButton)
    {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
        {
            let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeViewController.setInitialText(School.twitterShareDefaultMessage)
            
            self.presentViewController(composeViewController, animated: true, completion: nil)
        }
            
        else
        {
            let alert = UIAlertController(title: "Twitter Account", message: "Please login to a Twitter account in Settings to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}