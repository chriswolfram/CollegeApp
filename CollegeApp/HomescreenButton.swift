//
//  HomescreenButton.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/7/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class HomescreenButton: UIButton
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        self.exclusiveTouch = true
        
        //self.layer.borderWidth = 2
        //self.layer.borderColor = UIColor.whiteColor().CGColor
        //self.backgroundColor = self.backgroundColor?.colorWithAlphaComponent(0.8)
        
        /*var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        //self.layer.borderColor = UIColor(hue: hue, saturation: saturation-0.1, brightness: brightness-0.3, alpha: alpha).CGColor
        self.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha-0.2)*/
    }
    
    override func drawRect(rect: CGRect)
    {
        self.layer.cornerRadius = self.frame.height/2//3
    }
}