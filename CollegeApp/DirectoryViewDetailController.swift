//
//  DirectoryViewDetailController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/16/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI

class DirectoryViewDetailController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, CNContactViewControllerDelegate
{
    static private let storyboardIdentifier = "Main"
    static private let viewControllerIdentifier = "DirectoryViewDetailController"
    
    var directoryEntry: DirectoryEntry!
    var cellTypes: [String]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Configure table view
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    static func controllerForDirectoryEntry(entry: DirectoryEntry) -> DirectoryViewDetailController
    {
        let storyboard = UIStoryboard(name: DirectoryViewDetailController.storyboardIdentifier, bundle: nil)
        let detailView = storyboard.instantiateViewControllerWithIdentifier(DirectoryViewDetailController.viewControllerIdentifier) as! DirectoryViewDetailController
        
        detailView.directoryEntry = entry
        detailView.cellTypes = detailView.getCellTypes(entry)
        
        return detailView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellTypes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTypes[indexPath.row], forIndexPath: indexPath) as! DirectoryViewDetailCell
        
        cell.showDirectoryEntry(directoryEntry)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch(cellTypes[indexPath.row])
        {
        case "DirectoryViewDetailPhone":
            let alertController = UIAlertController(title: "Pick an action", message: nil, preferredStyle: .ActionSheet)
            
            alertController.addAction(UIAlertAction(title: "Call", style: .Default, handler: {action in self.callNumber(self.directoryEntry.phoneNumber!, formattedNumber: self.directoryEntry.formattedPhoneNumber!)}))
            alertController.addAction(UIAlertAction(title: "SMS", style: .Default, handler: {action in self.sendSMS(self.directoryEntry.phoneNumber!, formattedNumber: self.directoryEntry.formattedPhoneNumber!)}))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            
        case "DirectoryViewDetailEmail":
            sendEmail(directoryEntry.emailAddress!)
            
        case "DirectoryViewDetailAdd":
            addToContacts(directoryEntry)
            
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        switch(cellTypes[indexPath.row])
        {
        case "DirectoryViewDetailPrimary":
            return false
        default:
            return true
        }
    }
    
    func getCellTypes(directoryEntry: DirectoryEntry) -> [String]
    {
        let cells =
        [
            "DirectoryViewDetailPrimary",
            "DirectoryViewDetailPhone",
            "DirectoryViewDetailEmail",
            "DirectoryViewDetailAdd"
        ]
        
        return cells.filter
        {
            cellType in
                
            switch(cellType)
            {
            case "DirectoryViewDetailPhone":
                return directoryEntry.formattedPhoneNumber != nil && directoryEntry.phoneNumber != nil
            case "DirectoryViewDetailEmail":
                return directoryEntry.emailAddress != nil
                    
            default:
                return true
            }
        }
    }
    
    func sendEmail(emailAddress: String)
    {
        if !MFMailComposeViewController.canSendMail()
        {
            let alertController = UIAlertController(title: "Could not send mail to \(emailAddress).", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        
        mailViewController.setToRecipients([emailAddress])
        
        presentViewController(mailViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
    
    func messageComposeViewController(controller: MFMessageComposeViewController,
        didFinishWithResult result: MessageComposeResult)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addToContacts(directoryEntry: DirectoryEntry)
    {
        let contact = CNMutableContact()
        
        let splitName = directoryEntry.name.characters.split(" ").map({String($0)})
        contact.givenName = splitName.first!
        contact.familyName = splitName.last!
        
        if directoryEntry.phoneNumber != nil
        {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: directoryEntry.phoneNumber!))]
        }
        
        if directoryEntry.emailAddress != nil
        {
            contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: directoryEntry.emailAddress!)]
        }
        
        let contactViewController = CNContactViewController(forNewContact: contact)
        contactViewController.delegate = self
        
        navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func contactViewController(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?)
    {
        navigationController?.popViewControllerAnimated(true)
    }
}