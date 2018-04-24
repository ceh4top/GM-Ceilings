//
//  BrowserViewController.swift
//  GM Ceilings
//
//  Created by GM on 21.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var newView: UIView!
    var webView: WKWebView?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var URL = NSURL(string: "гмпотолки.рф") {
        didSet {
            openHref()
        }
    }
    
    public var NavTitle = "Браузер" {
        didSet {
            setNavTitle()
        }
    }
    
    func setNavTitle() {
        self.navigationItem.title = NavTitle
    }
    
    func openHref() {
        if let url = URL as? URL {
            let request = URLRequest(url: url)
            if self.webView != nil {
                self.webView!.load(request)
                self.activityIndicator.startAnimating()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView?.navigationDelegate = self
        
        checkInternetConnection()
        
        openHref()
        setNavTitle()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        let request = URLRequest(url: self.URL as! URL)
                        viewWeb.load(request)
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
