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
    static fileprivate let storyboardIdentifier = "Main"
    static fileprivate let viewControllerIdentifier = "DirectoryViewDetailController"
    
    var directoryEntry: DirectoryEntry!
    var cellTypes: [String]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Configure table view
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    static func controllerForDirectoryEntry(_ entry: DirectoryEntry) -> DirectoryViewDetailController
    {
        let storyboard = UIStoryboard(name: DirectoryViewDetailController.storyboardIdentifier, bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: DirectoryViewDetailController.viewControllerIdentifier) as! DirectoryViewDetailController
        
        detailView.directoryEntry = entry
        detailView.cellTypes = detailView.getCellTypes(entry)
        
        return detailView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTypes[indexPath.row], for: indexPath) as! DirectoryViewDetailCell
        
        cell.showDirectoryEntry(directoryEntry)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch(cellTypes[indexPath.row])
        {
        case "DirectoryViewDetailPhone":
            let alertController = UIAlertController(title: "Pick an action", message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Call", style: .default, handler: {action in self.callNumber(self.directoryEntry.phoneNumber!, formattedNumber: self.directoryEntry.formattedPhoneNumber!)}))
            alertController.addAction(UIAlertAction(title: "SMS", style: .default, handler: {action in self.sendSMS(self.directoryEntry.phoneNumber!, formattedNumber: self.directoryEntry.formattedPhoneNumber!)}))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        case "DirectoryViewDetailEmail":
            sendEmail(directoryEntry.emailAddress!)
            
        case "DirectoryViewDetailAdd":
            addToContacts(directoryEntry)
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        switch(cellTypes[indexPath.row])
        {
        case "DirectoryViewDetailPrimary":
            return false
        default:
            return true
        }
    }
    
    func getCellTypes(_ directoryEntry: DirectoryEntry) -> [String]
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
    
    func sendEmail(_ emailAddress: String)
    {
        if !MFMailComposeViewController.canSendMail()
        {
            let alertController = UIAlertController(title: "Could not send mail to \(emailAddress).", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        
        mailViewController.setToRecipients([emailAddress])
        
        present(mailViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addToContacts(_ directoryEntry: DirectoryEntry)
    {
        let contact = CNMutableContact()
        
        let splitName = directoryEntry.name.characters.split(separator: " ").map({String($0)})
        contact.givenName = splitName.first!
        contact.familyName = splitName.last!
        
        if directoryEntry.phoneNumber != nil
        {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: directoryEntry.phoneNumber!))]
        }
        
        if directoryEntry.emailAddress != nil
        {
            contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: directoryEntry.emailAddress! as NSString)]
        }
        
        let contactViewController = CNContactViewController(forNewContact: contact)
        contactViewController.delegate = self
        
        navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?)
    {
        navigationController?.popViewController(animated: true)
    }
}
