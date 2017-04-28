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
    fileprivate var internalPlayer: AVAudioPlayer?
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
    
    static func audioViewControllerFromPlayer(_ player: AVAudioPlayer?) -> AudioViewContoller
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AudioViewContoller") as! AudioViewContoller
        
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
            playButton?.isHidden = false
            
            if player!.isPlaying
            {
                playButton?.setBackgroundImage(pauseImage, for: UIControlState())
            }
            
            else
            {
                playButton?.setBackgroundImage(playImage, for: UIControlState())
            }
        }
        
        else
        {
            playButton?.isHidden = true
        }
    }
    
    @IBAction func playPressed(_ sender: UIButton)
    {
        if player != nil
        {
            if player!.isPlaying
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
    
    @IBAction func fastForwardPressed(_ sender: UIButton)
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
    
    @IBAction func rewindPressed(_ sender: UIButton)
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
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer)
    {
        updateButtons()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        updateButtons()
    }
}
