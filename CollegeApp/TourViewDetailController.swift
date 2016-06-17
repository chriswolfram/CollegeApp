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
    @IBOutlet weak var scrollViewOffsetConstraint: NSLayoutConstraint?
    {
        didSet
        {
            scrollViewOffsetConstraint?.constant = scrollViewOffset
        }
    }
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mediaView: UIView!
    
    var scrollCallback: ((UIScrollView) -> Void)?
    
    var scrollViewOffset: CGFloat = 300
    {
        didSet
        {
            scrollViewOffsetConstraint?.constant = scrollViewOffset
        }
    }
    
    var audioViewController: AudioViewContoller!
    var parentTourViewController: TourViewController!
    
    var height: CGFloat
    {
        return view.frame.height
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Change appearence
        contentView.layer.cornerRadius = 30
        contentView.clipsToBounds = true
        //contentView.layer.borderWidth = 3
        //contentView.layer.borderColor = UIColor.whiteColor().CGColor
        
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
        if landmark.audioURL != nil
        {
            audioViewController = AudioViewContoller.audioViewControllerFromPlayer(nil)
            landmark.getAudioPlayer({self.audioViewController.player = $0})
            
            let audioView = audioViewController.view
            audioView.translatesAutoresizingMaskIntoConstraints = false
            mediaView.addSubview(audioView)
            
            audioView.heightAnchor.constraintEqualToConstant(75).active = true
            
            audioView.topAnchor.constraintEqualToAnchor(lastBottomAnchor).active = true
            audioView.leftAnchor.constraintEqualToAnchor(mediaView.leftAnchor).active = true
            audioView.rightAnchor.constraintEqualToAnchor(mediaView.rightAnchor).active = true
            
            lastBottomAnchor = audioView.bottomAnchor
        }
        
        lastBottomAnchor.constraintLessThanOrEqualToAnchor(mediaView.bottomAnchor).active = true
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