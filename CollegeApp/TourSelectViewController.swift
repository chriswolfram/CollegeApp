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
            if let parser = NSXMLParser(contentsOfURL: NSURL(string: "https://www.wolframcloud.com/objects/9a34fc7d-4e68-43c9-b5a2-09f30505b869")!)
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
        if selectedLandmarks.count == 0
        {
            let alertController = UIAlertController(title: "Could not build the specified tour.", message: "Please select at least one landmark or press the 'select all' button on a group of landmarks.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        else
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
}