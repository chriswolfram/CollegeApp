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
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var thumbnailTintView: UIView!
    
    private static let normalColor = UIColor.clearColor()//UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    private static let highlightedColor = UIColor(red: 19/255, green: 115/255, blue: 229/255, alpha: 1)
    
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
                    self.highlightView.backgroundColor = TourSelectViewLandmarkCell.highlightedColor
                }
                
                else
                {
                    self.highlightView.backgroundColor = TourSelectViewLandmarkCell.normalColor
                }
            //}
        }
    }
    
    override func drawRect(rect: CGRect)
    {
        self.thumbnailView.layer.cornerRadius = self.thumbnailView.frame.width/2
        self.thumbnailView.clipsToBounds = true
        self.thumbnailTintView.layer.cornerRadius = self.thumbnailTintView.frame.width/2
        self.thumbnailTintView.clipsToBounds = true
        self.highlightView.layer.cornerRadius = self.highlightView.frame.width/2
        self.highlightView.clipsToBounds = true
        
        super.drawRect(rect)
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.thumbnailView.image = nil
    }
    
    func refreshImage()
    {
        landmark?.getImage({_ in self.thumbnailView.image = self.landmark?.image})
    }
    
    //This deals with autolayout bug
    override var bounds: CGRect
    {
        didSet
        {
            contentView.frame = bounds
            //self.frame = bounds
        }
    }
}