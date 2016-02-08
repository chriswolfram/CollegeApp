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
    static let useBeaconsTours = true
    
    static let tours =
    [
        Tour(
            landmarks: [
            TourLandmark(School.landmarks[0], descriptionString: "This is the first stop on this tour.  This place has historical significance, with many foos and bars living here over the years."),
                TourLandmark(School.landmarks[10], descriptionString: "This is a test of many descriptive things.", thumbnailPath: "HooverTower"),
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
    var thumbnailPath: String? = nil
    var major: NSNumber?
    var minor: NSNumber?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, descriptionString: String?, thumbnailPath: String? = nil, beaconMajor: NSNumber? = nil, beaconMinor: NSNumber? = nil)
    {
        super.init(coordinate: coordinate, title: title)
        self.descriptionString = descriptionString
        self.thumbnailPath = thumbnailPath
        self.major = beaconMajor
        self.minor = beaconMinor
    }
    
    convenience init(_ landmark: Landmark, descriptionString: String? = nil, thumbnailPath: String? = nil)
    {
        self.init(coordinate: landmark.coordinate, title: landmark.title, descriptionString: descriptionString, thumbnailPath: thumbnailPath)
    }
}

protocol TourDelegate
{
    func tour(tour: Tour, newIndex: Int)
}

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