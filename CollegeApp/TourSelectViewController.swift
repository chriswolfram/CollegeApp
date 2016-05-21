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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Update tour data
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            if let parser = NSXMLParser(contentsOfURL: NSURL(string: "https://www.wolframcloud.com/objects/6116ba94-7cbf-4406-aa49-3fc89c653310")!)
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
        return School.tours.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TourSelectViewPresetCell", forIndexPath: indexPath) as! TourSelectViewPresetCell
        
        let tour = School.tours[indexPath.row]
        cell.tour = tour
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let tour = School.tours[indexPath.row]
        let viewController = TourViewController.tourViewControllerFromTour(tour)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}