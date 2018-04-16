//
//  ViewController.swift
//  GM Celings
//
//  Created by GM on 09.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation

class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var newViewStrong: UIView!
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var containerView : UIView! = nil
    var webView: WKWebView?
    
    var locationManager:CLLocationManager! = CLLocationManager()
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController();
        
        contentController.add(
            self,
            name: "callbackAddress"
        )
        
        contentController.add(
            self,
            name: "callbackConsole"
        )
        
        let coordinate = locationManager.location?.coordinate
        
        if coordinate != nil {
            let stringP : String = "GoAddressP('" + (coordinate?.latitude.description)! + "', '" + (coordinate?.longitude.description)! + "')";
            
            let userScript = WKUserScript(
                source: stringP,
                injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
                forMainFrameOnly: true
            )
            contentController.addUserScript(userScript)
        }
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.webView = WKWebView(
            frame: self.newView.bounds,
            configuration: config
        )
        
        self.stackView.removeArrangedSubview(self.newView)
        self.stackView.insertArrangedSubview(self.webView!, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        if let search = self.navigationBar.titleView as? UISearchBar {
            search.placeholder = "Введите адрес"
        }
        
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "index", ofType: "html")!)
        let req = NSURLRequest(url:url as URL)
        self.webView!.load(req as URLRequest)
        
        self.webView?.navigationDelegate = self
        
        self.activityIndicator.startAnimating()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackAddress")
        {
            print("Address: \(message.body)")
            if let search = self.navigationItem.titleView as? UISearchBar {
                search.text! = message.body as! String
                webView?.evaluateJavaScript("GoAddress('\(search.text!)')");
            }
        }
        else if (message.name == "callbackStart") {
            
        }
        else if (message.name == "callbackConsole")
        {
            print("WebConsole: \(message.body)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowForm" {
            if let fvc = segue.destination as? FormViewController {
                if let search = self.navigationItem.titleView as? UISearchBar {
                    if search.text! != "" {
                        fvc.clientAddressMap = search.text
                    }
                }
            }
        }
        self.navigationItem.title = "Карта"
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowForm" {
            if let search = self.navigationItem.titleView as? UISearchBar {
                if search.text! == "" {
                    Message.Show(title: "Не указан адрес", message: "Для успешного заказа потолка введите адрес", controller: self)
                    return false
                }
            }
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchText as String! {
            webView?.evaluateJavaScript("GoAddress('\(text)')");
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        webView?.evaluateJavaScript("GetAddress()");
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }
}

