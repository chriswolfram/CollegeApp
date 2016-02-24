//
//  TourViewDetailController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/22/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourViewDetailController: UIViewController
{
    static private let storyboardIdentifier = "Main"
    
    var landmark: TourLandmark!
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var thumbnailView: UIImageView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if landmark != nil
        {
            showLandmark(landmark)
        }
    }
    
    func showLandmark(newLandmark: TourLandmark)
    {
        landmark = newLandmark
        
        nameLabel?.text = landmark.title
        descriptionLabel?.text = landmark.descriptionString
        
        if landmark.thumbnailPath != nil, let bundlePath = NSBundle.mainBundle().pathForResource(landmark.thumbnailPath, ofType: "jpg"), let image = UIImage(contentsOfFile: bundlePath)
        {
            thumbnailView?.image = image
            thumbnailView?.addConstraint(NSLayoutConstraint(item: thumbnailView!, attribute: .Width, relatedBy: .Equal, toItem: thumbnailView!, attribute: .Height, multiplier: image.size.width / image.size.height, constant: 0))
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
}