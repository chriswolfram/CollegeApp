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
    
    static var sharedInstance: TourViewPageController?
    
    var tour: Tour
    {
        return Tour.sharedInstance!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TourViewPageController.sharedInstance = self
        
        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([detailViewController(tour.currentLandmark)], direction: .Forward, animated: true, completion: nil)
    }
    
    func detailViewController(landmark: TourLandmark) -> TourViewDetailController
    {
        let detailView = storyboard!.instantiateViewControllerWithIdentifier(TourViewPageController.detailViewIdentifier) as! TourViewDetailController
        
        //Request the view (a computed property) to force the controller to instantiate its labels
        let _ = detailView.view
        
        detailView.showLandmark(landmark)
        
        return detailView
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
    
    func updateDetailView(tour: Tour)
    {
        self.setViewControllers([detailViewController(tour.currentLandmark)], direction: .Forward, animated: true, completion: nil)
    }
}