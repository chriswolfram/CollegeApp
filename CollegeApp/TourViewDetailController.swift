//
//  TourViewDetailController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/22/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourViewDetailController: UIViewController
{
    var landmark: TourLandmark!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func showLandmark(newLandmark: TourLandmark)
    {
        landmark = newLandmark
        nameLabel.text = newLandmark.title
        descriptionLabel.text = newLandmark.descriptionString
    }
}