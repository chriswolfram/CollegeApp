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
    static let useBeaconsTours = false
    
    static let tours =
    [
        Tour(
            landmarks: [
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.427926, longitude: -122.166893), title: "Hoover Tower", descriptionString: "Standing 285 feet tall, Hoover Tower was an finished in 1941: the year of Stanford's 50th anniversary. On clear days it is possible to see all the way to the distant skyline of San Francisco.", thumbnailPath: "Hoover"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.433619, longitude: -122.162194), title: "Stanford Stadium", descriptionString: "A new $100 million stadium was unveiled in 2006. Originally built in 1921, Stanford Stadium played host to many historic events including Herbert Hoover's 1928 presidential nomination acceptance speech, US-USSR track & field meet in 1962, several Olympic soccer matches in 1984, Super Bowl XIX, FIFA World Cup soccer matches in 1994, FIFA Women's World Cup soccer matches in 1999, and of course, numerous college football games.", thumbnailPath: "Stadium"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.437311, longitude: -122.168883), title: "Angel of Grief", descriptionString: "Jane Lathrop Stanford commissioned the Angel of Grief in 1900 as a memorial for one of her brothers, Henry Clay Lathrop, after choosing the design from a photograph", thumbnailPath: "Angel"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.436460, longitude: -122.169876), title: "Mausoleum", descriptionString: "Jane Stanford commissioned the Stanford Family statue as a memorial to her family in 1890. The statue, cast in bronze in Florence, Italy, was not completed until 1899. Originally located in the Inner Quad, it was relocated several times.", thumbnailPath: "Mausoleum"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.435872, longitude: -122.171076), title: "Cactus Garden", descriptionString: nil, thumbnailPath: "Cactus"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.432947, longitude: -122.170486), title: "Cantor Arts Center", descriptionString: "Opened in 1894, it consists of over 130,000 square feet of space, including sculpture gardens. The Cantor Center houses one of the largest collections of Auguste Rodin sculptures, with 199 works by Rodin", thumbnailPath: "Cantor"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.424669, longitude: -122.184300), title: "Red Barn", descriptionString: "Constructed in 1878-79, the Red Barn is one of the few surviving structures on campus that predates the University’s establishment and is a Registered Historical Landmark.", thumbnailPath: "Barn"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.424195, longitude: -122.171092), title: "Tresidder Memorial Union", descriptionString: "Primary meeting and resource center for Stanford and the surrounding community. Features a variety of services, ranging from event facilities to a student-run store. It also includes dining, shopping, banking and administrative offices.", thumbnailPath: "Tresidder"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.427492, longitude: -122.170231), title: "The Main Quad", descriptionString: "Historic and academic center of campus, including the school of Humanities & Sciences", thumbnailPath: nil),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.427212, longitude: -122.170333), title: "Memorial Church", descriptionString: "Built in 1903, was one of the earliest, and is still among the most prominent, interdenominational churches in the West", thumbnailPath: "Memorial"),
                TourLandmark(coordinate: CLLocationCoordinate2D(latitude: 37.428000, longitude: -122.169972), title: "Burghers of Calais", descriptionString: "One of the most famous sculptures by Auguste Rodin, completed in 1889. It serves as a monument to an occurrence in 1347 during the Hundred Years' War", thumbnailPath: "Burghers")
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