//
//  MessageViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/10/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class MessageViewController: UITableViewController
{
    @IBOutlet weak var messageInputField: UITextField!
    
    var messageGroup: MessageGroup!
    var messages = [Message]()
    
    let senderId = UIDevice.currentDevice().identifierForVendor!.UUIDString
    let senderDisplayName = UIDevice.currentDevice().name
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Set appearence
        navigationItem.title = messageGroup.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadButtonPressed")
        
        //Setup table view
        self.tableView.estimatedRowHeight = 83
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Load older messages and show them
        reloadMessages()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    /*override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        //Setup and make request to add message to the server
        let urlComponents = NSURLComponents(URL: messageGroup.sendMessageURL, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems =
            [
                NSURLQueryItem(name: "from", value: senderId),
                NSURLQueryItem(name: "fromDisplay", value: senderDisplayName),
                NSURLQueryItem(name: "body", value: text)
            ]
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(urlComponents!.URL!)
        task.resume()
        
        //Add message to local list
        messages.append(Message(from: self.senderId, fromDisplay: self.senderDisplayName, body: text))
        
        self.finishSendingMessage()
    }*/
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageViewCell", forIndexPath: indexPath) as! MessageViewCell
        
        cell.showMessage(messages[indexPath.row])
        
        return cell
    }
    
    @IBAction func sendButtonPressed(sender: UIButton)
    {
        //Setup and make request to add message to the server
        let urlComponents = NSURLComponents(URL: messageGroup.sendMessageURL, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems =
        [
                NSURLQueryItem(name: "from", value: senderId),
                NSURLQueryItem(name: "fromDisplay", value: senderDisplayName),
                NSURLQueryItem(name: "body", value: messageInputField.text)
        ]
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(urlComponents!.URL!)
        task.resume()
        
        //Add message to local list
        messages.append(Message(from: self.senderId, fromDisplay: self.senderDisplayName, body: messageInputField.text!))
        tableView.reloadData()
        
        //Reset input field
        messageInputField.text = ""
    }
    
    func reloadMessages()
    {
        let xmlRoot = XMLElement(parser: NSXMLParser(contentsOfURL: messageGroup.messageListURL)!)
        xmlRoot.parse()
        
        let newMessages = xmlRoot["message", .All]?.map
            {
                message in
                return Message(from: message["from"]!.contents!, fromDisplay: message["fromDisplay"]!.contents!, body: message["body"]!.contents!)
        }
        
        if newMessages != nil
        {
            self.messages = newMessages!.flatMap({$0}).map({$0})
        }
    }
    
    func reloadButtonPressed()
    {
        reloadMessages()
        self.tableView.reloadData()
    }
    
    func showMessageGroup(messageGroup: MessageGroup)
    {
        self.messageGroup = messageGroup
    }
}

class Message
{
    let from: String
    let fromDisplay: String
    let body: String
    
    init(from: String, fromDisplay: String, body: String)
    {
        self.from = from
        self.fromDisplay = fromDisplay
        self.body = body
    }
}