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
                let alertController = UIAlertController(title: "Could not load tour information.", message: "Could not connect to tour server.  Make sure you are connected to the internet and try again in a few minutes.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in self.navigationController?.popToRootViewController(animated: true)}))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        //Add and configure search bar
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.setShowsCancelButton(false, animated: false)
        
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.tintColor = UIColor.white
        searchBar.placeholder = "Search for Landmarks"
        
        //Configure gesture recognizer to pick up taps to escape the search bar
        collectionView?.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: #selector(collectionViewTapped))
        
        gestureRecognizer.isEnabled = false
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TourSelectViewLandmarkCell", for: indexPath) as! TourSelectViewLandmarkCell
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if
            let cell = collectionView.cellForItem(at: indexPath) as? TourSelectViewLandmarkCell,
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
            collectionView.visibleCells.forEach
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TourSelectionHeaderView", for: indexPath) as! TourSelectionHeaderView
        
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
                    return landmark.titleString!.contains(text)
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
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem)
    {
        if selectedLandmarks.count == 0
        {
            let alertController = UIAlertController(title: "Could not build the specified tour.", message: "Please select at least one landmark or press the 'select all' button on a group of landmarks.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
                    let alertController = UIAlertController(title: "Could not build the specified tour.", message: "Please try again in a few minutes.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        gestureRecognizer.isEnabled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        gestureRecognizer.isEnabled = false
    }
    
    func collectionViewTapped()
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        updateSearchResults()
        collectionView?.reloadData()
    }
}
