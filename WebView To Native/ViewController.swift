//
//  ViewController.swift
//  WebView To Native
//
//  Created by Pawan kumar on 08/06/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//


import UIKit
import WebKit
import CoreLocation

class ViewController: UIViewController {
    
    var webView: WKWebView!
    @IBOutlet weak var webViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        let contentController = WKUserContentController();
        contentController.add(
            self,
            name: "NativeJavascriptInterface"
        )
        
        // 2
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        // 3
        webView = WKWebView(frame: webViewContainer.bounds, configuration: config)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        
        webView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor, constant: 0).isActive = true
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor, constant: 0).isActive = true
        
        //Load File
        if let url = Bundle.main.url(forResource: "addressform", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }

    func geocodeAddress(dict: NSDictionary) {
        let geocoder = CLGeocoder()
        let street = dict["street"] as? String ?? ""
        let city = dict["city"] as? String ?? ""
        let state = dict["state"] as? String ?? ""
        let country = dict["country"] as? String ?? ""
        
        let addressString = "\(street), \(city), \(state), \(country)"
        geocoder.geocodeAddressString(addressString, completionHandler: geocodeComplete)
    }
    
    func geocodeComplete(placemarks: [CLPlacemark]?, error: Error?) {
        if let placemarks = placemarks, placemarks.count > 0 {
            let lat = placemarks[0].location?.coordinate.latitude ?? 0.0
            let lon = placemarks[0].location?.coordinate.longitude ?? 0.0
            webView.evaluateJavaScript("setLatLon('\(lat)', '\(lon)')", completionHandler: nil)
        }
        
    }
}

extension ViewController:WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "NativeJavascriptInterface", let dict = message.body as? NSDictionary {
            geocodeAddress(dict: dict)
        }
    }
}
