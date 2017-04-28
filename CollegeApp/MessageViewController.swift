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
    
    let senderId = UIDevice.current.identifierForVendor!.uuidString
    let senderDisplayName = UIDevice.current.name
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Set appearence
        navigationItem.title = messageGroup.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(MessageViewController.reloadButtonPressed))
        
        //Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 83
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Setup text field
        messageInputField.autocapitalizationType = .sentences
        
        //Setup notifications for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillBeShown), name: /*UIKeyboardWillShowNotification*/NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.keyboardDismissMode = .interactive
        
        //Load older messages and show them
        if reloadMessages()
        {
            tableView.reloadData()
        }
        
        scrollToBottom()
        
        //Setup timer to load messages every second
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MessageViewController.reloadTimer), userInfo: nil, repeats: true)
    }
    
    func showMessageGroup(_ messageGroup: MessageGroup)
    {
        self.messageGroup = messageGroup
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath) as! MessageViewCell
        
        cell.showMessage(messages[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton)
    {
        //Setup and make request to add message to the server
        var urlComponents = URLComponents(url: messageGroup.sendMessageURL as URL, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems =
        [
                URLQueryItem(name: "from", value: senderId),
                URLQueryItem(name: "fromDisplay", value: senderDisplayName),
                URLQueryItem(name: "body", value: messageInputField.text)
        ]
        
        let task = URLSession.shared.dataTask(with: urlComponents!.url!)
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
        let xmlRoot = XMLElement(parser: XMLParser(contentsOf: messageGroup.messageListURL as URL)!)
        xmlRoot.parse()
        
        let newHash = xmlRoot.contents?.hashValue
        
        if newHash == messagesHash
        {
            return false
        }
        
        else
        {
            let newMessages = xmlRoot["message", .all]?.map
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
            tableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func keyboardWillBeShown(_ notification: Notification)
    {
        let userInfo = notification.userInfo!
        
        let keyboardHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size.height
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue!
        viewBottomContraint.constant = keyboardHeight
        UIView.animate(withDuration: animationDuration, animations: {self.view.layoutIfNeeded()}, completion: {i in self.scrollToBottom()})
    }
    
    func keyboardWillBeHidden(_ notification: Notification)
    {
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue!
        viewBottomContraint.constant = 0
        UIView.animate(withDuration: animationDuration, animations: {self.view.layoutIfNeeded()}, completion: {i in self.scrollToBottom()})
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
