//
//  BubbleViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 3/7/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class BubbleViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    
    var bubbleViews = [BubbleView]()
    let bubbleRadius: Float = 50
    let bubbleDistance: Float = 60
    
    let hexagonDirections = [(1,-1,0), (1,0,-1), (0,1,-1), (-1,1,0), (-1,0,1), (0,-1,1)]
    
    func cubeToUnitCoords(p: (Int, Int, Int)) -> (Float,Float)
    {
        return (3*Float(p.0)/2, sqrt(3) * (Float(p.0)/2 + Float(p.2)))
    }
    
    func cubeToUnitCoords(p: (Int, Int, Int), r: Float) -> (Float,Float)
    {
        return (3*Float(p.0)/2 * r, sqrt(3) * (Float(p.0)/2 + Float(p.2)) * r)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let bundlePath = NSBundle.mainBundle().pathForResource("Barn", ofType: "jpg")
        let image = UIImage(contentsOfFile: bundlePath!)
        
        //let bubbleView = BubbleView(position: CGPoint(x: 1000, y: 1000), radius: 50, image: image!)
        //let bubbleView = BubbleView(position: CGPoint(x: 1000, y: 1000), radius: 50)
        //bubbleView.backgroundColor = UIColor.redColor()
        
        let bubbleViewCount = 50
        var cubeCoords = [(0,0,0)]
        let radius = Int(ceil(radiusFromCount(bubbleViewCount)))
        
        (1...radius).forEach
        {
            r in
            var cube = (hexagonDirections[4].0 * r, hexagonDirections[4].1 * r, hexagonDirections[4].2 * r)
            (0...5).forEach
            {
                i in
                for _ in (0...r-1) where cubeCoords.count < bubbleViewCount
                {
                    cubeCoords.append(cube)
                    cube = (cube.0 + hexagonDirections[i].0, cube.1 + hexagonDirections[i].1, cube.2 + hexagonDirections[i].2)
                }
            }
        }
        
        let cubePositions = cubeCoords.map({cubeToUnitCoords($0, r: bubbleDistance)})
        
        scrollView.contentSize =
            CGSize(width:
                CGFloat(bubbleRadius*2 + cubePositions.maxElement({$0.0 < $1.0})!.0 - cubePositions.minElement({$0.0 < $1.0})!.0), height:
                CGFloat(bubbleRadius*2 + cubePositions.maxElement({$0.1 < $1.1})!.1 - cubePositions.minElement({$0.1 < $1.1})!.1))
        
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width/2, y: scrollView.contentSize.height/2)
                
        cubePositions.forEach
        {
            x,y in
            let xOffset = scrollView.contentOffset.x
            let yOffset = scrollView.contentOffset.y
            
            let bubbleView = BubbleView(position: CGPoint(x: xOffset + CGFloat(x), y: yOffset + CGFloat(y)), radius: bubbleRadius, image: image!)
            
            bubbleView.pressSelector =
            {
                let detailController = BubbleViewDetailController.bubbleViewDetailControllerFromImage(image!)
                self.navigationController?.pushViewController(detailController, animated: true)
            }
        
            scrollView.addSubview(bubbleView)
        
            bubbleViews.append(bubbleView)
        }
    }
    
    func radiusFromCount(c: Int) -> Float
    {
        return (sqrt(3)*sqrtf(4*Float(c)-1)-3)/6
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {        
        bubbleViews.forEach
        {
            bubbleView in
            bubbleView.refreshSizeInView(view)
        }
    }
}