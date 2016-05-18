//
//  AudioViewContoller.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/18/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewContoller: UIViewController
{
    var player: AVPlayer!
    
    @IBAction func playPressed(sender: UIButton)
    {
        player.play()
        print("play!")
    }
    
    static func audioViewControllerFromPlayer(player: AVPlayer) -> AudioViewContoller
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AudioViewContoller") as! AudioViewContoller
        
        viewController.player = player
        
        return viewController
    }
}