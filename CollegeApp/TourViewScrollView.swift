//
//  TourViewScrollView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 4/2/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourViewScrollView: UIScrollView
{
    //Area from the top to be pressed through
    var ignoredArea: CGFloat = 0
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        if point.y < ignoredArea
        {
            return false
        }
        
        return true
    }
}