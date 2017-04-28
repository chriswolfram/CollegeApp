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
    static fileprivate let storyboardIdentifier = "Main"
    
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
    
    func showLandmark(_ newLandmark: TourLandmark)
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
            imageView.contentMode = .scaleAspectFit
            
            landmark.getImage
            {
                image in
                
                imageView.image = image
                
                if image != nil
                {
                    imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: image!.size.width/image!.size.height, constant: 0))
                }
            }
            
            mediaView.addSubview(imageView)
            mediaView.bringSubview(toFront: imageView)
            
            imageView.topAnchor.constraint(equalTo: lastBottomAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: mediaView.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: mediaView.rightAnchor).isActive = true
            
            lastBottomAnchor = imageView.bottomAnchor
        }
        
        //Add video
        if let url = landmark.videoURL
        {
            let videoView = WKWebView(frame: mediaView.frame)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoView.scrollView.isScrollEnabled = false
            videoView.load(URLRequest(url: url as URL))
            mediaView.addSubview(videoView)
            mediaView.bringSubview(toFront: videoView)
            
            videoView.addConstraint(NSLayoutConstraint(item: videoView, attribute: .width, relatedBy: .equal, toItem: videoView, attribute: .height, multiplier: 16/9, constant: 0))
            
            videoView.topAnchor.constraint(equalTo: lastBottomAnchor).isActive = true
            videoView.leftAnchor.constraint(equalTo: mediaView.leftAnchor).isActive = true
            videoView.rightAnchor.constraint(equalTo: mediaView.rightAnchor).isActive = true
            
            lastBottomAnchor = videoView.bottomAnchor
        }
        
        //Add audio
        if landmark.audioURL != nil
        {
            audioViewController = AudioViewContoller.audioViewControllerFromPlayer(nil)
            landmark.getAudioPlayer({self.audioViewController.player = $0})
            
            let audioView = audioViewController.view
            audioView?.translatesAutoresizingMaskIntoConstraints = false
            mediaView.addSubview(audioView!)
            
            audioView?.heightAnchor.constraint(equalToConstant: 75).isActive = true
            
            audioView?.topAnchor.constraint(equalTo: lastBottomAnchor).isActive = true
            audioView?.leftAnchor.constraint(equalTo: mediaView.leftAnchor).isActive = true
            audioView?.rightAnchor.constraint(equalTo: mediaView.rightAnchor).isActive = true
            
            lastBottomAnchor = (audioView?.bottomAnchor)!
        }
        
        lastBottomAnchor.constraint(lessThanOrEqualTo: mediaView.bottomAnchor).isActive = true
    }
    
    static func controller() -> TourViewDetailController
    {
        let storyboard = UIStoryboard(name: TourViewDetailController.storyboardIdentifier, bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "TourViewDetailController") as! TourViewDetailController
        
        return detailView
    }
    
    static func controllerForLandmark(_ landmark: TourLandmark) -> TourViewDetailController
    {
        let storyboard = UIStoryboard(name: TourViewDetailController.storyboardIdentifier, bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "TourViewDetailController") as! TourViewDetailController
        detailView.landmark = landmark
        
        return detailView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        scrollCallback?(scrollView)
    }
}
