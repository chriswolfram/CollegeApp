//
//  StripedView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/12/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class StripedView: UIView
{
    var colors = [UIColor]()
    
    override func drawRect(rect: CGRect)
    {
        let stripeWidth = self.frame.width / CGFloat(colors.count)
        colors.enumerate().forEach
        {
            (i, color) in
            
            let rect = CGRect(x: self.frame.minX + CGFloat(i)*stripeWidth, y: self.frame.minY, width: stripeWidth, height: self.frame.height)
            
            color.set()
            UIRectFill(rect)
        }
    }
}