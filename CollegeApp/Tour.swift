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
    let title: String?
    let landmarks: [TourLandmark]
    var currentIndex = 0
    
    var currentLandmark: TourLandmark
    {
        get
        {
            return landmarks[currentIndex]
        }
    }
    
    init(landmarks: [TourLandmark], title: String? = nil, startIndex: Int = 0)
    {
        self.landmarks = landmarks
        self.title = title
        self.currentIndex = startIndex
    }
}