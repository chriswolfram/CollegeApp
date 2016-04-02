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
    
    
    static func qrDetailControllerFromString(qrCodeString: String, parent: QRViewController) -> QRDetailController
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("QRDetailController") as! QRDetailController
        
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