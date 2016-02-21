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
        //self.layer.cornerRadius = self.frame.height/2
        self.exclusiveTouch = true
        
        self.layer.borderWidth = 1.5
        self.layer.borderColor = self.backgroundColor?.CGColor
        self.backgroundColor = self.backgroundColor?.colorWithAlphaComponent(0.8)
    }
    
    override func drawRect(rect: CGRect)
    {
        self.layer.cornerRadius = self.frame.height/3
    }
}