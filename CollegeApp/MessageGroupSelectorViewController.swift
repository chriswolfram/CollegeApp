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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messageGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSelectorCell", for: indexPath) as! MessageSelectorCell
        let messageGroup = messageGroups[indexPath.row]
        
        cell.textLabel?.text = messageGroup.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let messageGroup = messageGroups[indexPath.row]
        
        //let messageViewController = MessageViewController(messageGroup: messageGroup)
        let messageViewController = storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        messageViewController.showMessageGroup(messageGroup)
        
        navigationController?.pushViewController(messageViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func reloadMessageGroups()
    {
        let xmlRoot = XMLElement(parser: XMLParser(contentsOf: School.messagesGroupsListURL as URL)!)
        xmlRoot.parse()
        
        //TODO: add error handling
        messageGroups = xmlRoot["messageGroup", .all]!.map({MessageGroup(name: $0["name"]!.contents!, messageListString: $0["messageList"]!.contents!, sendMessageString: $0["sendMessage"]!.contents!)}).flatMap({$0})
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl)
    {
        reloadMessageGroups()
        tableView.reloadData()
        
        refreshControl?.endRefreshing()
    }
}

class MessageGroup
{
    let name: String
    let messageListURL: URL
    let sendMessageURL: URL
    
    init(name: String, messageListURL: URL, sendMessageURL: URL)
    {
        self.name = name
        self.messageListURL = messageListURL
        self.sendMessageURL = sendMessageURL
    }
    
    convenience init?(name: String, messageListString: String, sendMessageString: String)
    {
        if let messageListURL = URL(string: messageListString), let sendMessageURL = URL(string: sendMessageString)
        {
            self.init(name: name, messageListURL: messageListURL, sendMessageURL: sendMessageURL)
        }
        
        else
        {
            return nil
        }
    }
}
