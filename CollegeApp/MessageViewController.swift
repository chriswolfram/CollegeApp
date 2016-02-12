//
//  MessageViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/10/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class MessageViewController: JSQMessagesViewController
{
    var messageGroup: MessageGroup!
    
    var messages = [JSQMessage]()
    let incomingBubbleFactory = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    let outgoingBubbleFactory = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    
    convenience init(messageGroup: MessageGroup)
    {
        self.init()
        
        self.messageGroup = messageGroup
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Remove accessory button
        self.inputToolbar?.contentView?.leftBarButtonItem = nil
        
        //Set appearence
        self.automaticallyScrollsToMostRecentMessage = true
        navigationItem.title = messageGroup.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadButtonPressed")
        
        //Set identity
        self.senderId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        self.senderDisplayName = UIDevice.currentDevice().name
        
        //Load older messages and show them
        reloadMessages()
        self.collectionView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.collectionView!.collectionViewLayout.springinessEnabled = true;
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
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
        messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text))
        
        self.finishSendingMessage()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
    {
        return self.messages[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!)
    {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId
        {
            return outgoingBubbleFactory
        }
        
        else
        {
            return incomingBubbleFactory
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        let incoming = false
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        return JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("CW", backgroundColor: UIColor.lightGrayColor(), textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
    }
    
    func reloadMessages()
    {
        let xmlRoot = XMLElement(parser: NSXMLParser(contentsOfURL: messageGroup.messageListURL)!)
        xmlRoot.parse()
        
        let newMessages = xmlRoot["message", .All]?.map
        {
            message in
            return JSQMessage(senderId: message["from"]?.contents, displayName: message["fromDisplay"]?.contents, text: message["body"]?.contents)
        }
        
        if newMessages != nil
        {
            self.messages = newMessages!.flatMap({$0}).map({$0!})
        }
    }
    
    func reloadButtonPressed()
    {
        reloadMessages()
        self.collectionView?.reloadData()
    }
}