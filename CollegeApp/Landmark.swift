//
//  Landmark.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import MapKit

class Landmark: NSObject, MKAnnotation
{
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, title: String?)
    {
        self.coordinate = coordinate
        self.title = title
    }
}