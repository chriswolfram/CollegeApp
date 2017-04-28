//
//  TourSelectionHeaderView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/22/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourSelectionHeaderView: UICollectionReusableView
{
    @IBOutlet weak var titleLabel: UILabel!
    var selectViewController: TourSelectViewController!
    
    var tour: Tour!
    {
        didSet
        {
            titleLabel.text = tour.title
        }
    }
    
    @IBAction func selectAllButtonPressed(_ sender: UIButton)
    {
        selectViewController.selectedLandmarks.formUnion(tour.landmarks)
        selectViewController.collectionView?.reloadData()
    }
}
