//
//  BubbleViewDetailController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 3/11/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class BubbleViewDetailController: UIViewController
{
    static fileprivate let storyboardIdentifier = "Main"
    static fileprivate let viewControllerIdentifier = "BubbleViewDetailController"
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if image != nil
        {
            imageView.image = image
        }
    }
    
    static func bubbleViewDetailControllerFromImage(_ image: UIImage) -> BubbleViewDetailController
    {
        let storyboard = UIStoryboard(name: BubbleViewDetailController.storyboardIdentifier, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! BubbleViewDetailController
        
        viewController.image = image
        
        return viewController
    }
}
