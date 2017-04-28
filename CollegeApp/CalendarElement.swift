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
        case all
        case first
        case last
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
        
        //Quick Swift 3 fix
        //for var i = 0; i < statements.count; i += 1
        var i = 0
        while(i < statements.count)
        {
            let (tag, contents) = statements[i]
            var child: CalendarElement!
            
            if tag == "BEGIN"
            {
                let endIndex = statements.dropFirst(i+1).index(where: {(tag, cont) in tag == "END" && cont == contents})!
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
            
            //End quick fix
            i+=1
        }
    }
    
    convenience init(string: String)
    {
        self.init(tag: "", statements: CalendarElement.statements(string))
    }
    
    convenience init?(url: URL)
    {
        if let string = try? String(contentsOf: url)
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
            case .all: return self.children?[key]
            case .first: return [self.children![key]![0]]
            case .last: return [self.children![key]!.last!]
            }
    }
    
    fileprivate static func statements(_ string: String) -> [(String, String)]
    {
        let lines = string.replacingOccurrences(of: "\r\n ", with: "").components(separatedBy: "\r\n").filter
        {
            $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""
        }
        
        let statements = lines.map
        {
            line -> (String, String) in
            
            let delimeterIndex = line.characters.index(of: ":")!
            
            return (line.substring(to: delimeterIndex), line.substring(from: line.index(after: delimeterIndex)).replacingOccurrences(of: "\\", with: ""))
        }
        
        return statements
    }
}
