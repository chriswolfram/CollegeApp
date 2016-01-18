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
    let emergencyContacts = SchoolInfo.emergencyContacts
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("EmergencyViewCell") as! EmergencyViewCell
        //self.view.backgroundColor = cell.backgroundColor
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
        
        cell.titleLabel.text = contact.title
        cell.numberLabel.text = contact.formattedNumber
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        callNumber(emergencyContacts[indexPath.row].number)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}