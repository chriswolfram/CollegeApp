//
//  QRViewController.swift
//  testing
//
//  Created by Christopher Wolfram on 12/9/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    var captureSession: AVCaptureSession!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        do
        {
            let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession.addInput(input as AVCaptureInput)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = view.frame
            view.layer.addSublayer(videoPreviewLayer)
            
            captureSession.startRunning()
        }
        
        catch _
        {
            //If the camera could not be opened
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        if let metadataObj = metadataObjects.first where metadataObj.type == AVMetadataObjectTypeQRCode, let qrCodeText = (metadataObj as! AVMetadataMachineReadableCodeObject).stringValue
        {
            //This is run if a readable QR code is found
            //let detailView = QRDetailController.qrDetailControllerFromString(qrCodeText, parent: self)
            //navigationController?.pushViewController(detailView, animated: true)
            
            //captureSession.stopRunning()
        }
    }
}
