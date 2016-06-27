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
    
    static let schoolRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.8782, longitude: -117.237), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.01))//MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4300, longitude: -122.1700), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.01))
    
    static let messagesGroupsListURL = NSURL(string: "https://www.wolframcloud.com/objects/85c52512-8738-4d70-925d-89d816f6d77e")!
    
    static let facebookShareDefaultMessage = "Try out the UCSD Tours app!"
    static let twitterShareDefaultMessage = "Try out the UCSD Tours app!"
}