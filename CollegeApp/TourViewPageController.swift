//
//  TourViewPageController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/22/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourViewPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    static let detailViewIdentifier = "TourViewDetailController"
    
    var tour: Tour
    {
        return TourSingleton.tour
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([detailViewController(tour.currentLandmark)], direction: .Forward, animated: true, completion: nil)
    }
    
    func detailViewController(landmark: Landmark) -> TourViewDetailController
    {
        let controller = storyboard!.instantiateViewControllerWithIdentifier(TourViewPageController.detailViewIdentifier) as! TourViewDetailController
        
        //Request the view (a computer property) to force the controller to instantiate its labels
        let _ = controller.view
        
        controller.landmark = landmark
        controller.nameLabel.text = landmark.title
        
        return controller
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        tour.currentIndex = tour.landmarks.indexOf((viewController as! TourViewDetailController).landmark)!
        TourViewController.sharedInstance?.updateMap(tour)
        if let nextLandmark = tour.previousLandmark()
        {
            return detailViewController(nextLandmark)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        tour.currentIndex = tour.landmarks.indexOf((viewController as! TourViewDetailController).landmark)!
        TourViewController.sharedInstance?.updateMap(tour)
        if let nextLandmark = tour.nextLandmark()
        {
            return detailViewController(nextLandmark)
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return tour.landmarks.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return tour.currentIndex
    }
}