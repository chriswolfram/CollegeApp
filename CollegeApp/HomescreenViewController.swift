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

class HomescreenViewController: UIViewController
{
    @IBOutlet weak var backgroundImageView: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Set the background view to move with parallax
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 20
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
        
        backgroundImageView.addMotionEffect(group)
        
        /*let url = NSBundle.mainBundle().URLForResource("hooverTower", withExtension: "m4v")
        let avplayer = AVPlayer(URL: url!)
        let avplayerLayer = AVPlayerLayer(player: avplayer)
        avplayerLayer.frame = view.frame
        avplayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avplayer.play()
        
        view.layer.addSublayer(avplayerLayer)*/
    }
}