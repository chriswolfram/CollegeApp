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
    let emergencyContacts =
        [
            (title: "Emergency", number: "911", formattedNumber: "911"),
            (title: "Stanford Emergency Information Line", number: "1-650-725-5555", formattedNumber: "+1 650-725-5555"),
            (title: "Non-Emergency", number: "1-650-329-2413", formattedNumber: "+1 650-329-2413"),
            (title: "CAPS Hotline", number: "1-650-723-3785", formattedNumber: "+1 650-723-3785"),
            (title: "Bridge Peer Counseling", number: "1-650-723-3392", formattedNumber: "+1 650-723-3392"),
            (title: "SARA Office", number: "1-650-725-9129", formattedNumber: "+1 650-725-9129"),
            (title: "SARA 24-Hour Hotline", number: "1-650-725-9955", formattedNumber: "+1 650-725-9955")
        ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EmergencyViewCell") as! EmergencyViewCell
        
        self.view.backgroundColor = cell.backgroundColor
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