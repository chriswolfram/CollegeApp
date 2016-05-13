//
//  ShuttleViewStopCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/12/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class ShuttleViewStopCell: UITableViewCell
{
    @IBOutlet weak var stripedView: StripedView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var internalStop: ShuttleStop?
    var stop: ShuttleStop?
    {
        get
        {
            return internalStop
        }
        
        set(newStop)
        {
            internalStop = newStop
            
            if newStop != nil
            {
                //nameLabel.text = newStop?.name
                if newStop?.name != nil
                {
                    let textAttributes =
                        [
                            NSStrokeColorAttributeName : UIColor.blackColor(),
                            NSForegroundColorAttributeName : UIColor.whiteColor(),
                            NSStrokeWidthAttributeName : -4.0,
                        ]
                    
                    nameLabel.attributedText = NSAttributedString(string: newStop!.name!, attributes: textAttributes)
                }
                
                if let colors = stop?.routes.map({$0.color})
                {
                    stripedView.colors = Array(Set(colors))
                    stripedView.setNeedsDisplay()
                }
            }
        }
    }
}