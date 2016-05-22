//
//  AudioViewContoller.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/18/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewContoller: UIViewController, AVAudioPlayerDelegate
{
    private var internalPlayer: AVAudioPlayer?
    var player: AVAudioPlayer?
    {
        get
        {
            return internalPlayer
        }
        
        set(newPlayer)
        {
            internalPlayer = newPlayer
            newPlayer?.delegate = self
            
            updateButtons()
        }
    }
    
    @IBOutlet weak var playButton: UIButton?
    
    let playImage = UIImage(named: "PlayFilled-100.png")
    let pauseImage = UIImage(named: "PauseFilled-100.png")
    
    static func audioViewControllerFromPlayer(player: AVAudioPlayer?) -> AudioViewContoller
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AudioViewContoller") as! AudioViewContoller
        
        viewController.player = player
        
        return viewController
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateButtons()
    }
    
    func updateButtons()
    {
        if player != nil
        {
            playButton?.hidden = false
            
            if player!.playing
            {
                playButton?.setBackgroundImage(pauseImage, forState: .Normal)
            }
            
            else
            {
                playButton?.setBackgroundImage(playImage, forState: .Normal)
            }
        }
        
        else
        {
            playButton?.hidden = true
        }
    }
    
    @IBAction func playPressed(sender: UIButton)
    {
        if player != nil
        {
            if player!.playing
            {
                player!.pause()
            }
                
            else
            {
                player!.play()
            }
            
            updateButtons()
        }
    }
    
    @IBAction func fastForwardPressed(sender: UIButton)
    {
        if player != nil
        {
            var newTime = player!.currentTime + 5
            
            if newTime > player!.duration
            {
                newTime = player!.duration - 1
            }
            
            player!.currentTime = newTime
        }
    }
    
    @IBAction func rewindPressed(sender: UIButton)
    {
        if player != nil
        {
            var newTime = player!.currentTime - 5
            
            if newTime < 0
            {
                newTime = 0
            }
            
            player!.currentTime = newTime
        }
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer)
    {
        updateButtons()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        updateButtons()
    }
}