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
    let emergencyContacts = [(title: "Emergency", number: "911"), (title: "Christopher", number: "+1 617-459-1213")]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return emergencyContacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EmergencyViewCell", forIndexPath: indexPath) as! EmergencyViewCell
        
        let contact = emergencyContacts[indexPath.row]
        
        cell.titleLabel.text = contact.title
        cell.numberLabel.text = contact.number
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("calling \(emergencyContacts[indexPath.row])")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}