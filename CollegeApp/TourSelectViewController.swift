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
            if let parser = NSXMLParser(contentsOfURL: NSURL(string: "https://www.wolframcloud.com/objects/93641124-f840-4511-8df8-8a4c0c3fc572")!)
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
                    let tours = xmlElement["tours"]?["tour", .All]?.flatMap
                        {
                            (tourXML: XMLElement) -> Tour? in
                            
                            let tourLandmarks = tourXML["landmarkIndices"]?["index", .All]?.flatMap
                                {
                                    (indexXML: XMLElement) -> TourLandmark? in
                                    
                                    if
                                        let indexString = indexXML.contents,
                                        let index = Int(indexString)
                                        where 0 <= index && index < landmarks.count
                                    {
                                        return landmarks[index]
                                    }
                                    
                                    return nil
                            }
                            
                            if tourLandmarks != nil
                            {
                                return Tour(landmarks: tourLandmarks!, title: tourXML["title"]?.contents)
                            }
                            
                            return nil
                    }
                    
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
        
        print(indexPath)
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