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
        
        //Add blur background
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        effectView.frame = self.view.frame
        self.view.insertSubview(effectView, atIndex: 0)
        
        //Animated set to false because of a bug in UIPageViewController
        self.setViewControllers([detailViewController(tour.currentLandmark)], direction: .Forward, animated: false, completion: nil)
    }
    
    func detailViewController(landmark: TourLandmark) -> TourViewDetailController
    {
        return TourViewDetailController.controllerForLandmark(landmark)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let index = tour.landmarks.indexOf((viewController as! TourViewDetailController).landmark)! - 1
        if 0 <= index && index < tour.landmarks.count
        {
            return detailViewController(tour.landmarks[index])
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let index = tour.landmarks.indexOf((viewController as! TourViewDetailController).landmark)! + 1
        if 0 <= index && index < tour.landmarks.count
        {
            return detailViewController(tour.landmarks[index])
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed
        {
            tour.currentIndex = tour.landmarks.indexOf((pageViewController.viewControllers!.first! as! TourViewDetailController).landmark)!
            TourViewController.sharedInstance?.updateTourView(tour)
        }
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