//
//  SchoolTours.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/24/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import MapKit

extension School
{
    static let tours =
    [
        Tour(
            landmarks: [
            TourLandmark(School.landmarks[0], descriptionString: "This is the first stop on this tour.  This place has historical significance, with many foos and bars living here over the years."),
            TourLandmark(School.landmarks[10], descriptionString: "This is a test of many descriptive things."),
            TourLandmark(School.landmarks[12], descriptionString: "The next one purposfully has no description."),
            TourLandmark(School.landmarks[1]),
            ],
            title: "First Tour"
        )
    ]
}

class TourLandmark: Landmark
{
    var descriptionString: String? = nil
    
    init(coordinate: CLLocationCoordinate2D, title: String?, descriptionString: String?)
    {
        super.init(coordinate: coordinate, title: title)
        self.descriptionString = descriptionString
    }
    
    convenience init(_ landmark: Landmark, descriptionString: String? = nil)
    {
        self.init(coordinate: landmark.coordinate, title: landmark.title, descriptionString: descriptionString)
    }
}

class Tour
{
    static var sharedInstance: Tour?
    
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
    
    init(landmarks: [TourLandmark], title: String? = nil)
    {
        self.landmarks = landmarks
        self.title = title
    }
    
    func nextLandmark() -> TourLandmark?
    {
        if (currentIndex + 1) < landmarks.count
        {
            return landmarks[currentIndex + 1]
        }
        
        return nil
    }
    
    func previousLandmark() -> TourLandmark?
    {
        if (currentIndex - 1) >= 0
        {
            return landmarks[currentIndex - 1]
        }
        
        return nil
    }
}