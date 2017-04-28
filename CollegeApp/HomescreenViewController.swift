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
    
    let avplayer = AVPlayer(url:  Bundle.main.url(forResource: "homescreenBackground", withExtension: "mp4")!)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        
        avplayer.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(HomescreenViewController.finishedVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avplayer.currentItem)
        
        view.layer.addSublayer(avplayerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomescreenViewController.viewDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        avplayer.play()
    }
    
    func viewDidBecomeActive()
    {
        self.viewDidAppear(false)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        avplayer.play()
        
        School.newsStories = []
        School.events = []
        School.directoryEntries = []
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        avplayer.pause()
    }
    
    func finishedVideo()
    {
        avplayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        avplayer.play()
    }
    
    @IBAction func facebookButton(_ sender: UIButton)
    {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
        {
            let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeViewController?.setInitialText(School.facebookShareDefaultMessage)
            
            self.present(composeViewController!, animated: true, completion: nil)
        }
        
        else
        {
            let alert = UIAlertController(title: "Facebook Account", message: "Please login to a Facebook account in Settings to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func twitterButton(_ sender: UIButton)
    {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
        {
            let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeViewController?.setInitialText(School.twitterShareDefaultMessage)
            
            self.present(composeViewController!, animated: true, completion: nil)
        }
            
        else
        {
            let alert = UIAlertController(title: "Twitter Account", message: "Please login to a Twitter account in Settings to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
