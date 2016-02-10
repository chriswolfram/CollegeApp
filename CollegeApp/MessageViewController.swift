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
    var messages = [JSQMessage]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        automaticallyScrollsToMostRecentMessage = true
        navigationController?.navigationBar.topItem?.title = "Logout"
        self.senderId = "Christopher"
        self.senderDisplayName = "Chris Wolfram"
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.collectionView!.collectionViewLayout.springinessEnabled = true;
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        print(text)
        
        messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text))
        
        self.finishSendingMessage()
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.row]
    }
    
    /*override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        
    }*/
}