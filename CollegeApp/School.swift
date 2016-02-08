//
//  School.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/12/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation
import MapKit

class School
{
    static let name = "Stanford"
    
    static let beaconUUID = NSUUID(UUIDString: "DE810A8D-5519-44BD-8767-BC24521E386D")!
    
    static let schoolRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4300, longitude: -122.1700), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.01))
}