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
        return School.tours[section].landmarks.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TourSelectViewLandmarkCell", forIndexPath: indexPath) as! TourSelectViewLandmarkCell
        
        //Setup the cell (should be done in the cell code except for dequeue issues)
        cell.thumbnailView.layer.cornerRadius = 148/2
        cell.thumbnailView.clipsToBounds = true
        cell.highlightView.layer.cornerRadius = 158/2
        cell.highlightView.clipsToBounds = true
        
        cell.landmark = School.tours[indexPath.section].landmarks[indexPath.row]
        
        cell.landmarkSelected = selectedLandmarks.contains(cell.landmark!)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TourSelectViewLandmarkCell
        {
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
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return School.tours.count
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "TourSelectionHeaderView", forIndexPath: indexPath) as! TourSelectionHeaderView
        
        headerView.selectViewController = self
        headerView.tour = School.tours[indexPath.section]
        
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