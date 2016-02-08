//
//  EmergencyViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/23/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class EmergencyViewController: UITableViewController
{
    let emergencyContacts = School.emergencyContacts
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 84
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func callNumber(number: String)
    {
        if let url = NSURL(string: "telprompt://"+number)
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return emergencyContacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EmergencyViewCell", forIndexPath: indexPath) as! EmergencyViewCell
        let contact = emergencyContacts[indexPath.row]
        
        cell.showEmergencyContact(contact)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        callNumber(emergencyContacts[indexPath.row].number)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}