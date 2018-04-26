//
//  CalculateViewController.swift
//  GM Celings
//
//  Created by GM on 13.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation

class CalculateViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var newView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var webView: WKWebView?
    
    var latitude = "NULL"
    var longitude = "NULL"
    
    var url = NSURL(string: PList.calculation)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInternetConnection()
        
        if !Geoposition.isEmpty {
            self.latitude = Geoposition.latitude!.description
            self.longitude = Geoposition.longitude!.description
        }
        
        url = NSURL(string: PList.calculation + "&latitude=\(latitude)&longitude=\(longitude)")
        
        let request = NSURLRequest(url:url! as URL)
        self.webView!.load(request as URLRequest)
        
        self.webView?.navigationDelegate = self
        
        self.activityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController();
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.webView = WKWebView(
            frame: self.newView.bounds,
            configuration: config
        )
        
        self.stackView.removeArrangedSubview(self.newView)
        self.stackView.insertArrangedSubview(self.webView!, at: 0)
    }
    
    func checkInternetConnection() {
        if !InternetConnection.isConnectedToNetwork() {
            InternetConnection.messageConnection(controller: self)
            let queue = DispatchQueue.global(qos: .default)
            queue.async{
                while !InternetConnection.isConnectedToNetwork() {
                    sleep(3)
                }
                DispatchQueue.main.async {
                    if let viewWeb = self.webView {
                        let request = NSURLRequest(url:self.url! as URL)
                        viewWeb.load(request as URLRequest)
                    }
                }
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }
}
