//
//  TourSelectViewLandmarkCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/22/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourSelectViewLandmarkCell: UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    private static let normalColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    private static let highlightedColor = UIColor(red: 149/255, green: 171/255, blue: 234/255, alpha: 1)
    
    var landmark: TourLandmark?
    {
        didSet
        {
            self.titleLabel.text = landmark?.titleString
            refreshImage()
        }
    }
    
    var landmarkSelected: Bool = false
    {
        didSet
        {
            //UIView.animateWithDuration(0.1)
            //{
                if self.landmarkSelected
                {
                    self.backgroundColor = TourSelectViewLandmarkCell.highlightedColor
                }
                
                else
                {
                    self.backgroundColor = TourSelectViewLandmarkCell.normalColor
                }
            //}
        }
    }
    
    func refreshImage()
    {
        landmark?.getImage({self.thumbnailView.image = $0; print($0)})
    }
    
    //Fixing dequeue issues
    override func prepareForReuse()
    {
        self.setNeedsDisplay()
    }
    
    //This deals with autolayout bug
    override var bounds: CGRect
    {
        didSet
        {
            contentView.frame = bounds
        }
    }
}