//
//  QRDetailController.swift
//  testing
//
//  Created by Christopher Wolfram on 12/10/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class QRDetailController: UIViewController
{
    @IBOutlet var label: UILabel!
    
    var parentController: QRViewController!
    var qrCodeString: String?
    
    static private let storyboardIdentifier = "Main"
    static private let viewControllerIdentifier = "QRDetailController"
    
    static func qrDetailControllerFromString(qrCodeString: String, parent: QRViewController) -> QRDetailController
    {
        let storyboard = UIStoryboard(name: QRDetailController.storyboardIdentifier, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerIdentifier) as! QRDetailController
        
        viewController.qrCodeString = qrCodeString
        viewController.parentController = parent
        
        return viewController
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        label.text = qrCodeString
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        parentController.captureSession.startRunning()
    }
}