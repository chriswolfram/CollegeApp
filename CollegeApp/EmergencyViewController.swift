//
//  EmergencyViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/23/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation

class EmergencyViewController: UITableViewController, MFMessageComposeViewControllerDelegate
{
    let emergencyContacts = School.emergencyContacts
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 84
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        let contact = emergencyContacts[indexPath.row]
        
        if contact.smsEnabled
        {
            let alertController = UIAlertController(title: "Pick an emergency action", message: nil, preferredStyle: .ActionSheet)
        
            alertController.addAction(UIAlertAction(title: "Call", style: .Default, handler: {action in self.callNumber(contact.number, formattedNumber: contact.formattedNumber)}))
            alertController.addAction(UIAlertAction(title: "SMS", style: .Default, handler: {action in self.sendSMS(contact.number, formattedNumber: contact.formattedNumber)}))
            alertController.addAction(UIAlertAction(title: "SMS Location", style: .Default, handler: {action in self.sendLocation(contact.number, formattedNumber: contact.formattedNumber)}))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        else
        {
            callNumber(contact.number, formattedNumber: contact.formattedNumber)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func callNumber(number: String, formattedNumber: String)
    {
        if let url = NSURL(string: "telprompt://"+number)
        {
            if !UIApplication.sharedApplication().openURL(url)
            {
                let alertController = UIAlertController(title: "Could not call \(formattedNumber).", message: nil, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func sendSMS(number: String, formattedNumber: String)
    {
        if !MFMessageComposeViewController.canSendText()
        {
            let alertController = UIAlertController(title: "Could not send SMS to \(formattedNumber).", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let messageViewController = MFMessageComposeViewController()
        messageViewController.messageComposeDelegate = self
        
        messageViewController.recipients = [number]
        
        presentViewController(messageViewController, animated: true, completion: nil)
    }
    
    func sendLocation(number: String, formattedNumber: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let locManager = appDelegate.locManager
        
        if CLLocationManager.locationServicesEnabled()
        {
            //locManager.requestLocation()
        }
        
        guard MFMessageComposeViewController.canSendText() && CLLocationManager.locationServicesEnabled() && locManager.location != nil else
        {
            let alertController = UIAlertController(title: "Could not send location over SMS to \(formattedNumber).", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let messageViewController = MFMessageComposeViewController()
        messageViewController.messageComposeDelegate = self
        
        messageViewController.recipients = [number]
        messageViewController.body = "Latitude: \(locManager.location!.coordinate.latitude), Longitude: \(locManager.location!.coordinate.longitude), within \(locManager.location!.horizontalAccuracy) meters"
        
        presentViewController(messageViewController, animated: true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController,
        didFinishWithResult result: MessageComposeResult)
    {
            controller.dismissViewControllerAnimated(true, completion: nil)
    }
}