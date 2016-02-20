//
//  MessageGroupSelectorViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/11/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class MessageGroupSelectorViewController: UITableViewController
{
    var messageGroups = [MessageGroup]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        reloadMessageGroups()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messageGroups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageSelectorCell", forIndexPath: indexPath) as! MessageSelectorCell
        let messageGroup = messageGroups[indexPath.row]
        
        cell.textLabel?.text = messageGroup.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let messageGroup = messageGroups[indexPath.row]
        
        //let messageViewController = MessageViewController(messageGroup: messageGroup)
        let messageViewController = storyboard?.instantiateViewControllerWithIdentifier("MessageViewController") as! MessageViewController
        messageViewController.showMessageGroup(messageGroup)
        
        navigationController?.pushViewController(messageViewController, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func reloadMessageGroups()
    {
        let xmlRoot = XMLElement(parser: NSXMLParser(contentsOfURL: School.messagesGroupsListURL)!)
        xmlRoot.parse()
        
        //TODO: add error handling
        messageGroups = xmlRoot["messageGroup", .All]!.map({MessageGroup(name: $0["name"]!.contents!, messageListString: $0["messageList"]!.contents!, sendMessageString: $0["sendMessage"]!.contents!)}).flatMap({$0})
    }
    
    @IBAction func refresh(sender: UIRefreshControl)
    {
        reloadMessageGroups()
        tableView.reloadData()
        
        refreshControl?.endRefreshing()
    }
}

class MessageGroup
{
    let name: String
    let messageListURL: NSURL
    let sendMessageURL: NSURL
    
    init(name: String, messageListURL: NSURL, sendMessageURL: NSURL)
    {
        self.name = name
        self.messageListURL = messageListURL
        self.sendMessageURL = sendMessageURL
    }
    
    convenience init?(name: String, messageListString: String, sendMessageString: String)
    {
        if let messageListURL = NSURL(string: messageListString), let sendMessageURL = NSURL(string: sendMessageString)
        {
            self.init(name: name, messageListURL: messageListURL, sendMessageURL: sendMessageURL)
        }
        
        else
        {
            return nil
        }
    }
}