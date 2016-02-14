//
//  Tour.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation

class Tour
{
    static var sharedInstance: Tour?
    
    let title: String?
    let landmarks: [TourLandmark]
    var delegates = [TourDelegate]()
    private var internalCurrentIndex = 0
    var currentIndex: Int
        {
        get
        {
            return internalCurrentIndex
        }
        
        set(newIndex)
        {
            internalCurrentIndex = newIndex
            delegates.forEach({$0.tour(self, newIndex: newIndex)})
        }
    }
    
    var currentLandmark: TourLandmark
        {
        get
        {
            return landmarks[currentIndex]
        }
    }
    
    init(landmarks: [TourLandmark], title: String? = nil)
    {
        self.landmarks = landmarks
        self.title = title
    }
}