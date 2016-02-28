//
//  TestViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/26/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import WebKit

class TestViewController: UIViewController, UIScrollViewDelegate
{
    var webView: WKWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.frame)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        
        webView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        //webView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        webView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        //webView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        
        //webView.heightAnchor.constraintEqualToConstant(400).active = true
        //webView.widthAnchor.constraintEqualToConstant(300).active = true
        
        webView.heightAnchor.constraintEqualToAnchor(webView.scrollView.heightAnchor).active = true
        webView.widthAnchor.constraintEqualToAnchor(webView.scrollView.widthAnchor).active = true
        
        webView.backgroundColor = UIColor.redColor()
        
        //let url = NSURL(string: "http://www.kincola.com/embed/")!
        //webView.loadData(NSData(contentsOfURL: url)!, MIMEType: "html", characterEncodingName: "UTF-8", baseURL: url)
        
        webView.scrollView.scrollEnabled = false
        webView.scrollView.delegate = self
        
        webView.loadHTMLString("<!DOCTYPE html><html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, shrink-to-fit=no'></head><body style='margin-top: 0px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px; padding: 0;'><div id='fyu_372nsdz790' class='fyu_container fyu_vertical'></div><script>if(!window.FYU)var FYU={loading:0,loaded:0,events:{},add:function(e,t,n){var o,a=this;return FYU.ready(function(){fyu.net.request({url:'http:'+'//fyu.se/embed/'+e,success:function(r){var i=JSON.parse(r.responseText);if(i&&1===i.success){var d=document.getElementById(t),s=t+'_'+(new Date).getTime(),u=document.createElement('div');d.id=s,u.className='fyu_wrapper',d.appendChild(u),o=fyu.addViewer(u,e,i.path.replace('http:',''),{fy:i.fy,preload:n&&n.preload||0,autoplay:n&&n.autoplay||0,nologo:n&&n.nologo||0,nooverlay:n&&n.nooverlay||0,controls:{drag:!0,auto:!1},aspect:{mode:1,tolerance:.8},jsembed:1});for(var l in a.events[e])o['on'+l]=a.events[e][l];o.oninit&&o.oninit()}}})}),{uid:e,on:function(e,t){return a.events[this.uid]=a.events[this.uid]||{},a.events[this.uid][e]=t,this},resize:function(){var e=fyu.entries;for(var t in e)if(e[t].f_uid===this.uid){fyu.utils.fireEvent(e[t],'resize');break}}}}};FYU.loading||(FYU.loading=1,function(){var e=[];FYU.ready=function(t){FYU.loaded?t():e.push(t)},window.onFYUReady=function(){if(!FYU.loaded){FYU.loaded=1;for(var t=0;t<e.length;t++)e[t]();return!1}};var t=document.createElement('script');t.type='text/javascript',t.id='www-fyuse-script',t.src='http:'+'//fyu.se/embed/dist',t.async=!0;var n=document.getElementsByTagName('script')[0],o=!1;t.onload=t.onreadystatechange=function(){o||this.readyState&&'loaded'!==this.readyState&&'complete'!==this.readyState||(o=!0,t.onload=t.onreadystatechange=null,onFYUReady(),t&&t.parentNode&&t.parentNode.removeChild(t))},n.parentNode.insertBefore(t,n)}());</script><script>FYU.add('372nsdz790','fyu_372nsdz790',{'preload':1,'nologo':1});</script></body></html>", baseURL: nil)
        
        print(webView.scrollView.contentSize)
        
        //webView.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        //webView.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        //webView.setContentHuggingPriority(1000, forAxis: .Horizontal)
        //webView.setContentHuggingPriority(1000, forAxis: .Vertical)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        print(webView.scrollView.contentSize)
        return nil
    }
}