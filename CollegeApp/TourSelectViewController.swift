//
//  TourSelectViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 5/15/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class TourSelectViewController: UICollectionViewController, UISearchBarDelegate
{
    var selectedLandmarks: Set<TourLandmark> = []
    
    var searchBar = UISearchBar()
    var gestureRecognizer = UITapGestureRecognizer()
    
    var searchResults = [TourLandmark]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Update tour data
        School.refreshToursIfNeeded
        {
            //If sucessfully got tour data
            if $0
            {
                self.collectionView?.reloadData()
            }
            
            //If could not get tour data
            else
            {
                let alertController = UIAlertController(title: "Could not load tour information.", message: "Could not connect to tour server.  Make sure you are connected to the internet and try again in a few minutes.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {_ in self.navigationController?.popToRootViewControllerAnimated(true)}))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
        //Add and configure search bar
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.setShowsCancelButton(false, animated: false)
        
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.placeholder = "Search for Landmarks"
        
        //Configure gesture recognizer to pick up taps to escape the search bar
        collectionView?.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: #selector(collectionViewTapped))
        
        gestureRecognizer.enabled = false
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        if searchResults.isEmpty
        {
            //If not searching
            return School.tours.count
        }
            
        else
        {
            //If searching
            return 1
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if searchResults.isEmpty
        {
            //If not searching
            return School.tours[section].landmarks.count
        }
        
        else
        {
            //If searching
            return searchResults.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TourSelectViewLandmarkCell", forIndexPath: indexPath) as! TourSelectViewLandmarkCell
        
        if searchResults.isEmpty
        {
            //If not searching
            cell.landmark = School.tours[indexPath.section].landmarks[indexPath.row]
        }
        
        else
        {
            //If searching
            cell.landmark = searchResults[indexPath.row]
        }
        
        cell.landmarkSelected = selectedLandmarks.contains(cell.landmark!)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TourSelectViewLandmarkCell,
            let landmark = cell.landmark
        {
            if !selectedLandmarks.contains(landmark)//!cell.landmarkSelected
            {
                selectedLandmarks.insert(landmark)
                cell.landmarkSelected = true
            }
                
            else
            {
                selectedLandmarks.remove(landmark)
                cell.landmarkSelected = false
            }
            
            //Update other visible cells representing the same landmark to reflect selection changes
            collectionView.visibleCells().forEach
            {
                otherCell in
                
                if let c = otherCell as? TourSelectViewLandmarkCell
                {
                    if c.landmark == cell.landmark
                    {
                        c.landmarkSelected = cell.landmarkSelected
                    }
                }
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "TourSelectionHeaderView", forIndexPath: indexPath) as! TourSelectionHeaderView
        
        headerView.selectViewController = self
        
        if searchResults.isEmpty
        {
            //If not searching
            headerView.tour = School.tours[indexPath.section]
        }
        
        else
        {
            //If searching
            headerView.tour = Tour(landmarks: searchResults, title: "Search Results")
        }
        
        return headerView
    }
    
    func updateSearchResults()
    {
        if let text = searchBar.text
        {
            searchResults = School.tourLandmarks.filter
            {
                landmark in
                
                if landmark.titleString != nil
                {
                    return landmark.titleString!.containsString(text)
                }
                
                else
                {
                    return false
                }
            }
        }
        
        else
        {
            searchResults = []
        }
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
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        gestureRecognizer.enabled = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        gestureRecognizer.enabled = false
    }
    
    func collectionViewTapped()
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        updateSearchResults()
        collectionView?.reloadData()
    }
}