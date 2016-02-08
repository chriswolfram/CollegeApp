//
//  WebView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/7/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController
{
    var url: NSURL!
    
    convenience init(url: NSURL)
    {
        self.init()
        
        self.url = url
        
        let webView = WKWebView(frame: self.view.frame)
        webView.loadRequest(NSURLRequest(URL: url))
        self.view.addSubview(webView)
        
        //let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonPressed")
        //self.navigationItem.rightBarButtonItem = shareButton
    }
    
    /*func shareButtonPressed()
    {
        let activityViewController = UIActivityViewController(activityItems: [url, url.absoluteString], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }*/
}