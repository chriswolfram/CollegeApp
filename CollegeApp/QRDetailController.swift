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
    
    
    static func qrDetailControllerFromString(_ qrCodeString: String, parent: QRViewController) -> QRDetailController
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRDetailController") as! QRDetailController
        
        viewController.qrCodeString = qrCodeString
        viewController.parentController = parent
        
        return viewController
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        label.text = qrCodeString
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        parentController.captureSession.startRunning()
    }
}
