//
//  CalendarElement.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/12/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation

class CalendarElement
{
    let tag: String
    let contents: String?
    var childList: [CalendarElement]?
    var children: [String: [CalendarElement]]?
    
    var childTags: [String]?
    {
        get
        {
            return self.childList?.map({$0.tag})
        }
    }
    
    enum CalendarElementParts
    {
        case All
        case First
        case Last
    }
    
    init(tag: String, contents: String)
    {
        self.tag = tag
        self.contents = contents
    }
    
    init(tag: String, statements: [(String, String)])
    {
        self.tag = tag
        self.contents = nil
        self.childList = []
        self.children = [String: [CalendarElement]]()
        
        for var i = 0; i < statements.count; i++
        {
            let (tag, contents) = statements[i]
            var child: CalendarElement!
            
            if tag == "BEGIN"
            {
                let endIndex = statements.dropFirst(i+1).indexOf({(tag, cont) in tag == "END" && cont == contents})!
                child = CalendarElement(tag: contents, statements: Array(statements[i+1...endIndex-1]))
                
                i = endIndex
            }
            
            else
            {
                child = CalendarElement(tag: tag, contents: contents)
            }
            
            self.childList?.append(child)
            
            if self.children![child.tag] != nil
            {
                self.children![child.tag]?.append(child)
            }
            
            else
            {
                self.children![child.tag] = [child]
            }
        }
    }
    
    convenience init(string: String)
    {
        self.init(tag: "", statements: CalendarElement.statements(string))
    }
    
    convenience init?(url: NSURL)
    {
        if let string = try? String(contentsOfURL: url)
        {
            self.init(string: string)
        }
        
        else
        {
            return nil
        }
    }
    
    subscript(index: Int) -> CalendarElement?
    {
            return self.childList?[index]
    }
    
    subscript(key: String) -> CalendarElement?
    {
            return self.children?[key]?[0]
    }
    
    subscript(key: String, p: CalendarElementParts) -> [CalendarElement]?
    {
            switch p
            {
            case .All: return self.children?[key]
            case .First: return [self.children![key]![0]]
            case .Last: return [self.children![key]!.last!]
            }
    }
    
    private static func statements(string: String) -> [(String, String)]
    {
        let lines = string.stringByReplacingOccurrencesOfString("\r\n ", withString: "").componentsSeparatedByString("\r\n").filter
        {
            $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != ""
        }
        
        let statements = lines.map
        {
            line -> (String, String) in
            
            let delimeterIndex = line.characters.indexOf(":")!
            return (line.substringToIndex(delimeterIndex), line.substringFromIndex(delimeterIndex.advancedBy(1)).stringByReplacingOccurrencesOfString("\\", withString: ""))
        }
        
        return statements
    }
}