//
//  TourSelectViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/15/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourSelectViewController: UICollectionViewController
{
    var selectedLandmarks: Set<TourLandmark> = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Update tour data
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            if let parser = NSXMLParser(contentsOfURL: NSURL(string: "https://www.wolframcloud.com/objects/a1a32f02-0959-4b46-9168-7a27046f9de6")!)
            {
                let xmlElement = XMLElement(parser: parser)
                xmlElement.parse()
                
                //Get landmarks
                if let landmarks = xmlElement["landmarks"]?["landmark", .All]?.flatMap({TourLandmark(xmlElement: $0)})
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        School.tourLandmarks = landmarks
                    }
                    
                    //Get tours
                    let tours = xmlElement["tours"]?["tour", .All]?.flatMap({Tour(xmlElement: $0, landmarks: landmarks)})
                    
                    if tours != nil
                    {
                        dispatch_async(dispatch_get_main_queue())
                        {
                            School.tours = tours!
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            //For preset cells
            return School.tours.count
        case 1:
            //For landmark cells
            return School.tourLandmarks.count
        default:
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        switch indexPath.section
        {
        case 0:
            //For preset cells
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TourSelectViewPresetCell", forIndexPath: indexPath) as! TourSelectViewPresetCell
            
            cell.layer.cornerRadius = 10
            
            cell.tour = School.tours[indexPath.row]
            
            return cell
            
        default: //case 1:
            //For landmark cells
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TourSelectViewLandmarkCell", forIndexPath: indexPath) as! TourSelectViewLandmarkCell
            
            cell.thumbnailView.layer.cornerRadius = 90/2//cell.thumbnailView.frame.width/2
            cell.thumbnailView.clipsToBounds = true
            cell.thumbnailView.frame = cell.frame
            cell.thumbnailView.contentMode = .ScaleAspectFill
            
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
                        
            cell.landmark = School.tourLandmarks[indexPath.row]
            
            cell.landmarkSelected = selectedLandmarks.contains(cell.landmark!)
            
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.section
        {
        case 0:
            //For preset cells
            
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TourSelectViewPresetCell
            {
                if let newLandmarks = cell.tour?.landmarks
                {
                    selectedLandmarks.unionInPlace(newLandmarks)
                    collectionView.reloadData()
                }
            }
            
        default: //case 1:
            //For landmark cells
            
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TourSelectViewLandmarkCell
            {
                cell.layoutIfNeeded()
                //print(cell.thumbnailView.frame)
                print(cell.contentView.frame)
                //print(cell.frame)
                
                if !cell.landmarkSelected
                {
                    selectedLandmarks.insert(School.tourLandmarks[indexPath.row])
                    cell.landmarkSelected = true
                }
                
                else
                {
                    selectedLandmarks.remove(School.tourLandmarks[indexPath.row])
                    cell.landmarkSelected = false
                }
            }
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        //The presets and the landmarks
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "TourSelectionHeaderView", forIndexPath: indexPath) as! TourSelectionHeaderView
        
        switch indexPath.section
        {
        case 0:
            //For preset cells
            headerView.titleLabel.text = "Prebuilt Tours"
        case 1:
            //For landmark cells
            headerView.titleLabel.text = "Landmarks"
        default:
            headerView.titleLabel.text = ""
        }
        
        return headerView
    }
    
    @IBAction func nextButtonPressed(sender: UIBarButtonItem)
    {
        let tour = Tour(landmarks: Array(selectedLandmarks))
        
        tour.reorder
        {
            if $0
            {
                let viewController = TourViewController.tourViewControllerFromTour(tour)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            else
            {
                let alertController = UIAlertController(title: "Could not build the specified tour.", message: "Please try again in a few minutes.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}