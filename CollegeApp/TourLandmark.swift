//
//  TourLandmark.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import CoreLocation

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