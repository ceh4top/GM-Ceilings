//
//  CalculateViewController.swift
//  GM Celings
//
//  Created by GM on 13.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit
import WebKit

class CalculateViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var newView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !InternetConnection.isConnectedToNetwork() {
            Message.Show(title: "Нет подключения к интернету", message: "Для успешной работы приложения, необходимо быть подключенным к сети интернет.", controller: self)
        }
        
        let url = NSURL(string: "http://test1.gm-vrn.ru/index.php?option=com_gm_ceiling&view=calculationform2&type=calculator&subtype=calendar&calc_id=100&precalculation=1&api=1")
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
