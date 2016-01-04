//
//  XMLElement.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/3/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation

class XMLElement: NSObject, NSXMLParserDelegate
{
    var tag: String?
    var attributes: [String: String]!
    var contents: String?
    var children = [String: [XMLElement]]()
    var childList = [XMLElement]()
    var parent: XMLElement?
    
    enum XMLElementParts
    {
        case All
        case First
        case Last
    }
    
    private let xmlParser: NSXMLParser!
    
    required init(parser: NSXMLParser)
    {
        self.xmlParser = parser
    }
    
    subscript(index: Int) -> XMLElement?
    {
        return self.childList[index]
    }
    
    subscript(key: String) -> XMLElement?
    {
        return self.children[key]?[0]
    }
    
    subscript(key: String, p: XMLElementParts) -> [XMLElement]?
    {
        switch p
        {
        case .All: return self.children[key]
        case .First: return [self.children[key]![0]]
        case .Last: return [self.children[key]!.last!]
        }
    }
    
    func parse()
    {
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if contents == nil
        {
            contents = ""
        }
        
        self.contents! += string
        parent?.parser(parser, foundCharacters: string)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        let child = XMLElement(parser: xmlParser)
        xmlParser.delegate = child
        child.parent = self
        child.tag = elementName
        child.attributes = attributeDict
        
        self.childList.append(child)
        
        if self.children[child.tag!] != nil
        {
            self.children[child.tag!]?.append(child)
        }
        
        else
        {
            self.children[child.tag!] = [child]
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if self.tag == elementName
        {
            xmlParser.delegate = parent
        }
    }
}