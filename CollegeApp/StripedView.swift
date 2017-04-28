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
    
    override func draw(_ rect: CGRect)
    {
        let stripeWidth = self.frame.width / CGFloat(colors.count)
        colors.enumerated().forEach
        {
            (i, color) in
            
            let rect = CGRect(x: self.bounds.minX + CGFloat(i)*stripeWidth, y: self.bounds.minY, width: stripeWidth, height: self.bounds.height)
            
            color.set()
            UIRectFill(rect)
        }
    }
}
