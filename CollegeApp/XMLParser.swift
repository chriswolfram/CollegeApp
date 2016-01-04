//
//  XMLParser.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/3/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation

class XMLElement: NSObject, NSXMLParserDelegate
{
    var attributes: [String: String]!
    var tag: String?
    var contents: String?
    var children = [XMLElement]()
    
    //State information
    private let xmlParser: NSXMLParser!
    private var currentTag = ""
    private var currentContents = ""
    
    init(url: NSURL)
    {
        xmlParser = NSXMLParser(contentsOfURL: url)
    }
    
    init(data: NSData)
    {
        xmlParser = NSXMLParser(data: data)
    }
    
    func run()
    {
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        currentContents += string
        print(string)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        currentTag = elementName
        self.attributes = attributeDict
        self.tag = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        print("\(currentTag), \(elementName)")
        if currentTag == elementName
        {
            self.contents = currentContents
            self.children.append(XMLElement(data: currentContents.dataUsingEncoding(NSUTF8StringEncoding)!))
            self.children.last?.run()
            currentContents = ""
        }
    }
}