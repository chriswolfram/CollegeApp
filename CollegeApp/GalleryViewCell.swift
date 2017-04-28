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
    
    func showFyuse(_ fyuseView: FyuseViewController)
    {
        self.fyuseView = fyuseView
        
        self.removeFyuse()
        
        print("adding")
        
        contentView.addSubview(fyuseView.imageView)
        
        fyuseView.imageView.backgroundColor = UIColor.red
        
        fyuseView.imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        fyuseView.imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        fyuseView.imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        fyuseView.imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        //fyuseView.imageView.addConstraint(NSLayoutConstraint(item: fyuseView.imageView, attribute: .Width, relatedBy: .Equal, toItem: fyuseView.imageView, attribute: .Height, multiplier: 1080/1920, constant: 0))
        
        fyuseView.imageView.contentMode = .scaleAspectFill
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
