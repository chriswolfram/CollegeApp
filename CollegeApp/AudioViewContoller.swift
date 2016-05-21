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
    @IBOutlet weak var playButton: UIButton!
    
    var playing = false
    
    let playImage = UIImage(named: "PlayFilled-100.png")
    let pauseImage = UIImage(named: "PauseFilled-100.png")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        player.actionAtItemEnd = .Pause
    }
    
    @IBAction func playPressed(sender: UIButton)
    {
        playing = !playing
        
        if playing
        {
            player.play()
            playButton.setBackgroundImage(pauseImage, forState: .Normal)
            
            print(player.currentTime())
            print(player.currentItem)
            
            if CMTimeCompare(player.currentTime(), player.currentItem!.duration) == 0
            {
                player.seekToTime(kCMTimeZero)
            }
        }
            
        else
        {
            player.pause()
            playButton.setBackgroundImage(playImage, forState: .Normal)
        }
    }
    
    @IBAction func fastForwardPressed(sender: UIButton)
    {
        let currentTime = player.currentTime()
        
        let seconds = CMTimeGetSeconds(currentTime) + 5
        var newTime = CMTimeMakeWithSeconds(seconds, currentTime.timescale)
        
        if CMTimeCompare(newTime, player.currentItem!.duration) == -1
        {
            player.pause()
            player.currentItem!.seekToTime(newTime)
        }
        
        else
        {
            player.pause()
            player.currentItem!.seekToTime(player.currentItem!.duration)
        }
        
        if playing
        {
            player.play()
        }
    }
    
    @IBAction func rewindPressed(sender: UIButton)
    {
        let currentTime = player.currentTime()
        
        var newTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(currentTime) - 5, currentTime.timescale)
        
        if newTime.value <= 0
        {
            newTime = kCMTimeZero
        }
        
        player.pause()
        player.seekToTime(newTime)
        
        if playing
        {
            player.play()
        }
    }
    
    static func audioViewControllerFromPlayer(player: AVPlayer) -> AudioViewContoller
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AudioViewContoller") as! AudioViewContoller
        
        viewController.player = player
        
        return viewController
    }
}