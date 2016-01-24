//
//  SchoolLandmarks.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/24/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import MapKit

class SchoolLandmarks
{
    static let landmarks =
    [
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.233363, longitude: -71.114025), title: "156 House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.2419815, longitude: -71.1160764), title: "874 Brush Hill Road"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.241688, longitude: -71.116643), title: "886 Brush Hill Road"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.241011, longitude: -71.114564), title: "Academic and Performance Center"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.237939, longitude: -71.117662), title: "Admission"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.234622, longitude: -71.11416), title: "Alumni Recreation Center (ARC)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.240377, longitude: -71.115844), title: "Basketball Courts (outdoor)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.2375861, longitude: -71.1172297), title: "Bell Hall"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238213, longitude: -71.116402), title: "Bookstore"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238332, longitude: -71.117325), title: "Brown House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.236088, longitude: -71.112523), title: "Buildings and Grounds"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238455, longitude: -71.115045), title: "Center for Career Development"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.235448, longitude: -71.114192), title: "Cottage"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.240083, longitude: -71.112475), title: "D. Forbes Will Athletic Complex"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.234598, longitude: -71.114267), title: "Dance Studio"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238769, longitude: -71.114471), title: "Dean of Students"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.237919, longitude: -71.116439), title: "Dining Services (Sodexo)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.232891, longitude: -71.114605), title: "Early Childhood Center"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238781, longitude: -71.114444), title: "Faculty Center"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.241342, longitude: -71.114326), title: "Faculty Office Building"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.237772, longitude: -71.116504), title: "Fitness Center"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238904, longitude: -71.116906), title: "Green House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238523, longitude: -71.116772), title: "Grey House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.240524, longitude: -71.114251), title: "Hafer Academic Building"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.240258, longitude: -71.116595), title: "Health Services"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.240731, longitude: -71.114084), title: "Hirsh Communication Center (TV Studio)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238519, longitude: -71.1149), title: "Human Resources"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.240699, longitude: -71.112373), title: "Katz Field"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238086, longitude: -71.116836), title: "Katz Gymnasium"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.242065, longitude: -71.113124), title: "Keith Alumni House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.241144, longitude: -71.114734), title: "Keith Auditorium"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.235651, longitude: -71.113248), title: "Kennedy Academic Building (Technology Center)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238586, longitude: -71.115029), title: "King Academic Administration Building"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.240723, longitude: -71.114927), title: "Levin Memorial Library"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.24191, longitude: -71.113661), title: "Lombard Hall"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238094, longitude: -71.116498), title: "Mail Services and Copy/Supply Center"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.235119, longitude: -71.111107), title: "Main Entrance"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.234781, longitude: -71.11336), title: "Main House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.241914, longitude: -71.114669), title: "Mayflower Hall"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.23946, longitude: -71.114959), title: "Miller Field House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.234158, longitude: -71.115286), title: "Milton Hall"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.242629, longitude: -71.114487), title: "North Campus Residence Hall (NCRH)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.239956, longitude: -71.114959), title: "North Hall"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.234674, longitude: -71.113687), title: "PAL - Webb Learning Center"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.23865, longitude: -71.114444), title: "Payroll"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.239063, longitude: -71.116455), title: "Presidents House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238769, longitude: -71.115442), title: "Presidents Office"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.241632, longitude: -71.114798), title: "Public Safety Office"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.241005, longitude: -71.113902), title: "Radio Station (WMLN)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238673, longitude: -71.113827), title: "Registrar's Office"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.23799, longitude: -71.11616), title: "Residence Life"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.24274, longitude: -71.115511), title: "Rose Hall"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.243169, longitude: -71.114492), title: "Scholars Hall"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.240202, longitude: -71.114825), title: "Science Building"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.239742, longitude: -71.111955), title: "Softball Diamond"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.234007, longitude: -71.114347), title: "South Campus Residence Hall (SCRH)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.241255, longitude: -71.113596), title: "State House"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.237875, longitude: -71.11615), title: "Student Activities"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238006, longitude: -71.116134), title: "Student Center"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238709, longitude: -71.114095), title: "Student Financial Services"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.238658, longitude: -71.114369), title: "Telecom Services"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.237172, longitude: -71.112202), title: "Tennis Courts"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.236024, longitude: -71.11424), title: "The Suites"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.2438, longitude: -71.093422), title: "Ulin Rink (off-campus)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.239825, longitude: -71.113301), title: "Vallely Baseball Diamond"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.234674, longitude: -71.113687), title: "Webb Learning Center (PAL)"),
        Landmark(coordinate: CLLocationCoordinate2D(latitude: 42.235437, longitude: -71.114573), title: "White House")
    ]
}

class Landmark: NSObject, MKAnnotation
{
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, title: String)
    {
        self.coordinate = coordinate
        self.title = title
    }
}