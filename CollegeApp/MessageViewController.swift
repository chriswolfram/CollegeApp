//
//  MessageViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/10/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageInputField: UITextField!
    @IBOutlet weak var viewBottomContraint: NSLayoutConstraint!
    
    var messageGroup: MessageGroup!
    var messages = [Message]()
    var messagesHash: Int?
    
    let senderId = UIDevice.currentDevice().identifierForVendor!.UUIDString
    let senderDisplayName = UIDevice.currentDevice().name
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Set appearence
        navigationItem.title = messageGroup.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(MessageViewController.reloadButtonPressed))
        
        //Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 83
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Setup text field
        messageInputField.autocapitalizationType = .Sentences
        
        //Setup notifications for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageViewController.keyboardWillBeShown), name: /*UIKeyboardWillShowNotification*/UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageViewController.keyboardWillBeHidden), name: UIKeyboardWillHideNotification, object: nil)
        
        tableView.keyboardDismissMode = .Interactive
        
        //Load older messages and show them
        if reloadMessages()
        {
            tableView.reloadData()
        }
        
        scrollToBottom()
        
        //Setup timer to load messages every second
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(MessageViewController.reloadTimer), userInfo: nil, repeats: true)
    }
    
    func showMessageGroup(messageGroup: MessageGroup)
    {
        self.messageGroup = messageGroup
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageViewCell", forIndexPath: indexPath) as! MessageViewCell
        
        cell.showMessage(messages[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        scrollToBottom()
    }
    
    func reloadMessages() -> Bool
    {
        let xmlRoot = XMLElement(parser: NSXMLParser(contentsOfURL: messageGroup.messageListURL)!)
        xmlRoot.parse()
        
        let newHash = xmlRoot.contents?.hashValue
        
        if newHash == messagesHash
        {
            return false
        }
        
        else
        {
            let newMessages = xmlRoot["message", .All]?.map
            {
                message in
                return Message(from: message["from"]!.contents!, fromDisplay: message["fromDisplay"]!.contents!, body: message["body"]!.contents!)
            }
            
            if newMessages != nil
            {
                self.messages = newMessages!.flatMap({$0}).map({$0})
                messagesHash = newHash
                
                return true
            }
            
            else
            {
                return false
            }
        }
    }
    
    func reloadTimer()
    {
        if reloadMessages()
        {
            tableView.reloadData()
        }
    }
    
    func reloadButtonPressed()
    {
        if reloadMessages()
        {
            tableView.reloadData()
        }
        
        scrollToBottom()
    }
    
    func scrollToBottom()
    {
        if messages.count > 0
        {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: messages.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
    
    func keyboardWillBeShown(notification: NSNotification)
    {
        let userInfo = notification.userInfo!
        
        let keyboardHeight = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size.height
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue!
        viewBottomContraint.constant = keyboardHeight
        UIView.animateWithDuration(animationDuration, animations: {self.view.layoutIfNeeded()}, completion: {i in self.scrollToBottom()})
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        let userInfo = notification.userInfo!
        
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue!
        viewBottomContraint.constant = 0
        UIView.animateWithDuration(animationDuration, animations: {self.view.layoutIfNeeded()}, completion: {i in self.scrollToBottom()})
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