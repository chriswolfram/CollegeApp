//
//  GravitationalBody.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 6/2/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

protocol GravitationalBody: class
{
    var center: CGPoint {get set}
    var mass: CGFloat {get set}
    var radius: CGFloat {get set}
    var bufferRadius: CGFloat {get set}
    var velocity: CGPoint {get set}
    var force: CGPoint {get set}
    
    var collisions: Bool {get}
    var hookeLaw: Bool {get}
    
    func applyForce(_ timeStep: TimeInterval)
}

class PointMass: GravitationalBody
{
    var center: CGPoint
    var mass: CGFloat
    var radius: CGFloat = 0
    var bufferRadius: CGFloat = 0
    
    var velocity: CGPoint
        {
        get {return CGPoint.zero}
        set {}
    }
    
    var force: CGPoint
        {
        get {return CGPoint.zero}
        set {}
    }
    
    let collisions = false
    let hookeLaw = false
    
    init(center: CGPoint, mass: CGFloat = 1)
    {
        self.center = center
        self.mass = mass
    }
    
    func applyForce(_ timeStep: TimeInterval)
    {
        //Intentionally does nothing because this object doesn't move.
    }
}
