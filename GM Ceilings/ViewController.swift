//
//  ViewController.swift
//  GM Ceilings
//
//  Created by GM on 09.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation

class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var newViewStrong: UIView!
    @IBOutlet weak var nextPage: StyleUIButton!
    @IBOutlet weak var calcPage: StyleUIButton!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    var webView: WKWebView?
    
    var locationManager:CLLocationManager! = CLLocationManager()
    
    @IBAction func showCalc(_ sender: StyleUIButton) {
        
        self.tabBarController?.selectedIndex = 0
    }
    
    
    override func loadView() {
        super.loadView()
        
        checkInternetConnection()
        
        let contentController = WKUserContentController();
        
        contentController.add(
            self,
            name: "callbackAddress"
        )
        
        contentController.add(
            self,
            name: "callbackConsole"
        )
        
        if !Geoposition.isEmpty {
            let stringP : String = "GoAddressP('" + Geoposition.latitude!.description + "', '" + Geoposition.longitude!.description + "');";
            
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
                        viewWeb.reload()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.isFirstLoad() && InternetConnection.isConnectedToNetwork() {
            self.performSegue(withIdentifier: "learning", sender: nil)
        }
        
        if !PList.isEmptyProperty() {
            let property = PList.property
            self.nextPage.setTitle(property["Заказать замер"], for: .normal)
            self.calcPage.setTitle(property["Самостоятельный замер"], for: .normal)
        }
        
        self.nextPage.layer.cornerRadius = 10
        self.calcPage.layer.cornerRadius = 10
        
        if let search = self.navigationBar.titleView as? UISearchBar {
            search.placeholder = "Введите адрес"
            search.enablesReturnKeyAutomatically = false
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
            //print("Address: \(message.body)")
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

