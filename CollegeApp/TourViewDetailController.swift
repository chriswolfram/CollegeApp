//
//  TourViewDetailController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/22/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import WebKit
//import MediaPlayer

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
        
        //Temporary
        loadViewIfNeeded()
        
        var lastBottomAnchor = mediaView.topAnchor
        
        //Load video
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
        
        //Load audio
        if let url = landmark.audioURL
        {
            let audioView = WKWebView(frame: mediaView.frame)
            audioView.translatesAutoresizingMaskIntoConstraints = false
            audioView.scrollView.scrollEnabled = false
            audioView.loadRequest(NSURLRequest(URL: url))
            mediaView.addSubview(audioView)
            mediaView.bringSubviewToFront(audioView)
            
            audioView.addConstraint(NSLayoutConstraint(item: audioView, attribute: .Width, relatedBy: .Equal, toItem: audioView, attribute: .Height, multiplier: 16/9, constant: 0))
            
            audioView.topAnchor.constraintEqualToAnchor(lastBottomAnchor).active = true
            audioView.leftAnchor.constraintEqualToAnchor(mediaView.leftAnchor).active = true
            audioView.rightAnchor.constraintEqualToAnchor(mediaView.rightAnchor).active = true
            
            lastBottomAnchor = audioView.bottomAnchor
        }
        
        //Load image
        if let url = landmark.imageURL
        {
            let imageView = WKWebView(frame: mediaView.frame)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.scrollView.scrollEnabled = false
            imageView.loadRequest(NSURLRequest(URL: url))
            mediaView.addSubview(imageView)
            mediaView.bringSubviewToFront(imageView)
            
            imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: imageView, attribute: .Height, multiplier: 16/9, constant: 0))
            
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
        detailView.showLandmark(landmark)
        
        return detailView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        scrollCallback?(scrollView)
    }
}