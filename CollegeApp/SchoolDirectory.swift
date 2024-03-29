//
//  SchoolDirectory.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/16/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation

extension School
{
    static fileprivate var directoryEntriesPrivate: [DirectoryEntry]?
    static var directoryEntries: [DirectoryEntry]
    {
        get
        {
            if directoryEntriesPrivate == nil
            {
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: "DirectoryEntries", ofType: "xml")!)
                let root = XMLElement(parser: XMLParser(contentsOf: url)!)
                root.parse()
                
                directoryEntriesPrivate = root["person", .all]!.map
                {
                    xmlPerson in
                        
                    DirectoryEntry(name: xmlPerson["name"]!.contents!, title: xmlPerson["title"]?.contents, department: xmlPerson["department"]?.contents, phoneNumber: xmlPerson["phone"]?.contents, formattedPhoneNumber: xmlPerson["formattedPhone"]?.contents, emailAddress: xmlPerson["email"]?.contents)
                }
            }
            
            return directoryEntriesPrivate!
        }
        
        set(newValue)
        {
            if newValue.count == 0
            {
                directoryEntriesPrivate = nil
            }
            
            else
            {
                directoryEntriesPrivate = newValue
            }
        }
    }
}
