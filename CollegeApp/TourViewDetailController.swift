//
//  TourViewDetailController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/22/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourViewDetailController: UIViewController, UIScrollViewDelegate
{
    static private let storyboardIdentifier = "Main"
    
    var landmark: TourLandmark!
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var thumbnailView: UIImageView?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
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
        
        if landmark.image != nil
        {
            thumbnailView?.image = landmark.image
            thumbnailView?.addConstraint(NSLayoutConstraint(item: thumbnailView!, attribute: .Width, relatedBy: .Equal, toItem: thumbnailView!, attribute: .Height, multiplier: landmark.image!.size.width / landmark.image!.size.height, constant: 0))
        }
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