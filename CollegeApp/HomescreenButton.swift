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
    }
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 50
        self.exclusiveTouch = true
        
        self.layer.borderWidth = 3.0
        self.layer.borderColor = self.backgroundColor?.CGColor
        //self.setTitleColor(self.backgroundColor, forState: .Normal)
        self.backgroundColor = UIColor.clearColor()
        
        //Add blur background
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        effectView.frame = self.frame
        self.addSubview(effectView)
    }
}