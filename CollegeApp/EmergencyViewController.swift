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

class EmergencyViewController: UITableViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate
{
    let emergencyContacts = School.emergencyContacts
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 84
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return emergencyContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmergencyViewCell", for: indexPath) as! EmergencyViewCell
        let contact = emergencyContacts[indexPath.row]
        
        cell.showEmergencyContact(contact)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let contact = emergencyContacts[indexPath.row]
        
        if contact.smsEnabled
        {
            let alertController = UIAlertController(title: "Pick an emergency action", message: nil, preferredStyle: .actionSheet)
        
            alertController.addAction(UIAlertAction(title: "Call", style: .default, handler: {action in self.callNumber(contact.number, formattedNumber: contact.formattedNumber)}))
            alertController.addAction(UIAlertAction(title: "SMS", style: .default, handler: {action in self.sendSMS(contact.number, formattedNumber: contact.formattedNumber)}))
            alertController.addAction(UIAlertAction(title: "SMS Location", style: .default, handler: {action in self.sendLocation(contact.number, formattedNumber: contact.formattedNumber)}))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            present(alertController, animated: true, completion: nil)
        }
        
        else
        {
            callNumber(contact.number, formattedNumber: contact.formattedNumber)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func callNumber(_ number: String, formattedNumber: String)
    {
        if let url = URL(string: "telprompt://"+number)
        {
            if !UIApplication.shared.openURL(url)
            {
                let alertController = UIAlertController(title: "Could not call \(formattedNumber).", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func sendSMS(_ number: String, formattedNumber: String)
    {
        if !MFMessageComposeViewController.canSendText()
        {
            let alertController = UIAlertController(title: "Could not send SMS to \(formattedNumber).", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let messageViewController = MFMessageComposeViewController()
        messageViewController.messageComposeDelegate = self
        
        messageViewController.recipients = [number]
        
        present(messageViewController, animated: true, completion: nil)
    }
    
    func sendLocation(_ number: String, formattedNumber: String)
    {
        let locManager = LocationManager.sharedInstance
        
        guard MFMessageComposeViewController.canSendText() && CLLocationManager.locationServicesEnabled() && locManager.location != nil else
        {
            let alertController = UIAlertController(title: "Could not send location over SMS to \(formattedNumber).", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let messageViewController = MFMessageComposeViewController()
        messageViewController.messageComposeDelegate = self
        
        messageViewController.recipients = [number]
        messageViewController.body = "Latitude: \(locManager.location!.coordinate.latitude), Longitude: \(locManager.location!.coordinate.longitude), within \(locManager.location!.horizontalAccuracy) meters"
        
        present(messageViewController, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult)
    {
            controller.dismiss(animated: true, completion: nil)
    }
}
