//
//  ArticleViewController.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2018 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class ArticleViewController: UIViewController {
    
    let spinner = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(spinner)
        self.spinner.center = self.view.center
        self.spinner.startAnimating()
        let webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        if let webUrl = URL(string: "http://dsp.test-sites.internal.nativo.net/external/moblie_web.html") {
            webView.load(URLRequest(url: webUrl))
        }
    }
}

extension ArticleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        
        // Place middle-of-article ad in web view
        NativoSDK.placeAd(in: webView, forSection: "http://www.nativo.net/moap")
    }
    
}
