//
//  TourViewDetailController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/22/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import WebKit

class TourViewDetailController: UIViewController, UIScrollViewDelegate
{
    static private let storyboardIdentifier = "Main"
    
    var landmark: TourLandmark!
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mediaView: UIView!
    
    var scrollCallback: ((UIScrollView) -> Void)?
    
    var audioViewController: AudioViewContoller!
    
    var height: CGFloat
    {
        return view.frame.height
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        if landmark != nil
        {
            showLandmark(landmark)
        }
    }
    
    func showLandmark(newLandmark: TourLandmark)
    {
        landmark = newLandmark
        
        nameLabel?.text = landmark.titleString
        descriptionLabel?.text = landmark.textString
        
        var lastBottomAnchor = mediaView.topAnchor
        
        //Add video
        if let url = landmark.videoURL
        {
            let videoView = WKWebView(frame: mediaView.frame)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoView.scrollView.scrollEnabled = false
            videoView.loadRequest(NSURLRequest(URL: url))
            mediaView.addSubview(videoView)
            mediaView.bringSubviewToFront(videoView)
            
            videoView.addConstraint(NSLayoutConstraint(item: videoView, attribute: .Width, relatedBy: .Equal, toItem: videoView, attribute: .Height, multiplier: 16/9, constant: 0))
            
            videoView.topAnchor.constraintEqualToAnchor(lastBottomAnchor).active = true
            videoView.leftAnchor.constraintEqualToAnchor(mediaView.leftAnchor).active = true
            videoView.rightAnchor.constraintEqualToAnchor(mediaView.rightAnchor).active = true
            
            lastBottomAnchor = videoView.bottomAnchor
        }
        
        //Add audio
        if let url = landmark.audioURL
        {
            /*let audioView = WKWebView(frame: mediaView.frame)
            audioView.translatesAutoresizingMaskIntoConstraints = false
            audioView.scrollView.scrollEnabled = false
            audioView.loadRequest(NSURLRequest(URL: url))
            mediaView.addSubview(audioView)
            mediaView.bringSubviewToFront(audioView)
            
            audioView.addConstraint(NSLayoutConstraint(item: audioView, attribute: .Width, relatedBy: .Equal, toItem: audioView, attribute: .Height, multiplier: 16/9, constant: 0))
            
            audioView.topAnchor.constraintEqualToAnchor(lastBottomAnchor).active = true
            audioView.leftAnchor.constraintEqualToAnchor(mediaView.leftAnchor).active = true
            audioView.rightAnchor.constraintEqualToAnchor(mediaView.rightAnchor).active = true
            
            lastBottomAnchor = audioView.bottomAnchor*/
            
            //Testing
            //landmark.audioPlayer?.play()
            
            audioViewController = AudioViewContoller.audioViewControllerFromPlayer(landmark.audioPlayer!)
            let audioView = audioViewController.view
            audioView.translatesAutoresizingMaskIntoConstraints = false
            mediaView.addSubview(audioView)
            
            audioView.addConstraint(NSLayoutConstraint(item: audioView, attribute: .Width, relatedBy: .Equal, toItem: audioView, attribute: .Height, multiplier: 16/9, constant: 0))
            
            audioView.topAnchor.constraintEqualToAnchor(lastBottomAnchor).active = true
            audioView.leftAnchor.constraintEqualToAnchor(mediaView.leftAnchor).active = true
            audioView.rightAnchor.constraintEqualToAnchor(mediaView.rightAnchor).active = true
            
            lastBottomAnchor = audioView.bottomAnchor
        }
        
        //Add image
        if landmark.imageURL != nil
        {
            let imageView = UIImageView(frame: mediaView.frame)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .ScaleAspectFit
            
            landmark.getImage
            {
                image in
                
                imageView.image = image
                
                if image != nil
                {
                    imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: imageView, attribute: .Height, multiplier: image!.size.width/image!.size.height, constant: 0))
                }
            }
            
            mediaView.addSubview(imageView)
            mediaView.bringSubviewToFront(imageView)
            
            imageView.topAnchor.constraintEqualToAnchor(lastBottomAnchor).active = true
            imageView.leftAnchor.constraintEqualToAnchor(mediaView.leftAnchor).active = true
            imageView.rightAnchor.constraintEqualToAnchor(mediaView.rightAnchor).active = true
            
            lastBottomAnchor = imageView.bottomAnchor
        }
        
        lastBottomAnchor.constraintEqualToAnchor(mediaView.bottomAnchor).active = true
    }
    
    static func controller() -> TourViewDetailController
    {
        let storyboard = UIStoryboard(name: TourViewDetailController.storyboardIdentifier, bundle: nil)
        let detailView = storyboard.instantiateViewControllerWithIdentifier("TourViewDetailController") as! TourViewDetailController
        
        return detailView
    }
    
    static func controllerForLandmark(landmark: TourLandmark) -> TourViewDetailController
    {
        let storyboard = UIStoryboard(name: TourViewDetailController.storyboardIdentifier, bundle: nil)
        let detailView = storyboard.instantiateViewControllerWithIdentifier("TourViewDetailController") as! TourViewDetailController
        detailView.landmark = landmark
        
        return detailView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        scrollCallback?(scrollView)
    }
}