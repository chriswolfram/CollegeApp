//
//  GalleryViewCell.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/25/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import WebKit

class GalleryViewCell: UITableViewCell
{
    var fyuseView: FyuseViewController?
    
    func showFyuse(fyuseView: FyuseViewController)
    {
        self.fyuseView = fyuseView
        
        self.removeFyuse()
        
        print("adding")
        
        contentView.addSubview(fyuseView.imageView)
        
        fyuseView.imageView.backgroundColor = UIColor.redColor()
        
        fyuseView.imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        fyuseView.imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        fyuseView.imageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        fyuseView.imageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
        
        //fyuseView.imageView.addConstraint(NSLayoutConstraint(item: fyuseView.imageView, attribute: .Width, relatedBy: .Equal, toItem: fyuseView.imageView, attribute: .Height, multiplier: 1080/1920, constant: 0))
        
        fyuseView.imageView.contentMode = .ScaleAspectFill
    }
    
    func removeFyuse()
    {
        if fyuseView != nil
        {
            print("removing")
            fyuseView!.imageView.removeConstraints(fyuseView!.imageView.constraints)
            //fyuseView!.imageView.removeFromSuperview()
        }
    }
}