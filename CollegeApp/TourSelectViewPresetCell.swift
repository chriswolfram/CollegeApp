//
//  TourSelectViewPresetCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/15/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourSelectViewPresetCell: UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    private var internalTour: Tour?
    var tour: Tour?
    {
        get
        {
            return internalTour
        }
        
        set(newTour)
        {
            internalTour = newTour
            
            if newTour != nil
            {
                titleLabel.text = newTour!.title
                refreshImage()
            }
        }
    }
    
    func refreshImage()
    {
        tour?.getImage({self.thumbnailView.image = $0})
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