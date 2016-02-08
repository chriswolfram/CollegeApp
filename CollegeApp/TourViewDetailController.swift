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
    var landmark: TourLandmark!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView?
    
    func showLandmark(newLandmark: TourLandmark)
    {
        landmark = newLandmark
        nameLabel.text = newLandmark.title
        descriptionLabel.text = newLandmark.descriptionString
        
        if newLandmark.thumbnailPath != nil, let bundlePath = NSBundle.mainBundle().pathForResource(newLandmark.thumbnailPath, ofType: "jpg"), let image = UIImage(contentsOfFile: bundlePath)
        {
            thumbnailView?.image = image
        }
    }
    
    static func controllerForLandmark(landmark: TourLandmark, storyboard: UIStoryboard?) -> TourViewDetailController
    {
        var detailView: TourViewDetailController!
        if landmark.thumbnailPath != nil
        {
            detailView = storyboard!.instantiateViewControllerWithIdentifier("TourViewDetailController") as! TourViewDetailController
        }
            
        else
        {
            detailView = storyboard!.instantiateViewControllerWithIdentifier("TourViewDetailNoImageController") as! TourViewDetailController
        }
        
        //Request the view (a computed property) to force the controller to instantiate its labels
        let _ = detailView.view
        
        detailView.showLandmark(landmark)
        
        return detailView
    }
    
    @IBAction func tapRecognizer(sender: UITapGestureRecognizer)
    {
        let popover = storyboard?.instantiateViewControllerWithIdentifier("TourViewDetailControllerPopover") as! TourViewDetailControllerPopover
        
        let _ = popover.view
        
        popover.titleLabel.text = landmark.title
        popover.descriptionLabel.text = landmark.descriptionString
        
        if landmark.thumbnailPath != nil, let bundlePath = NSBundle.mainBundle().pathForResource(landmark.thumbnailPath, ofType: "jpg"), let image = UIImage(contentsOfFile: bundlePath)
        {
            popover.imageView.image = image
        }
        
        navigationController?.pushViewController(popover, animated: true)
    }
}