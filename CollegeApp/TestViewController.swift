//
//  TestViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/28/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TestViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    let fyuseIdentifiers = ["3rofz4ixjt", "abbcj9dy5l", "7bw92gpkmr", "372nsdz790"]
    var fyuseViews = [FyuseViewController]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.userInteractionEnabled = false
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //contentView.userInteractionEnabled = false
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        
        /*let fyuseView1 = FyuseViewController()
        fyuseView1.imageView.backgroundColor = UIColor.redColor()
        view.addSubview(fyuseView1.imageView)
        fyuseView1.imageView.frame = view.frame
        
        let fyuseView2 = FyuseViewController()
        view.addSubview(fyuseView2.imageView)
        fyuseView2.imageView.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height/2)
        
        fyuseView1.showFyuse("372nsdz790")
        fyuseView2.showFyuse("3rofz4ixjt")
        
        fyuseViews = [fyuseView1, fyuseView2]*/
        
        var previousAnchor = contentView.topAnchor
        
        fyuseIdentifiers.forEach
        {
            identifier in
            
            let fyuseView = FyuseViewController()
            
            fyuseViews.append(fyuseView)
            
            contentView.addSubview(fyuseView.imageView)
            
            fyuseView.imageView.backgroundColor = UIColor.redColor()
            fyuseView.imageView.userInteractionEnabled = false
            
            fyuseView.imageView.topAnchor.constraintEqualToAnchor(previousAnchor).active = true
            fyuseView.imageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
            fyuseView.imageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
            //fyuseView.imageView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
            //fyuseView.imageView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
            
            //fyuseView.imageView.addConstraint(NSLayoutConstraint(item: fyuseView.imageView, attribute: .Width, relatedBy: .Equal, toItem: fyuseView.imageView, attribute: .Height, multiplier: 9/16, constant: 0))
            
            previousAnchor = fyuseView.imageView.bottomAnchor
            
            fyuseView.imageView.contentMode = .ScaleAspectFill
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                fyuseView.showFyuse(identifier)
            }
            print("-------------------------------------------NEXT")
        }
        
        //scrollView.contentSize = CGSize(width: 375, height: 2000)
        //scrollView.layoutIfNeeded()
    }
}