//
//  ViewController.swift
//  roam
//
//  Created by Ruben Nieves on 12/15/20.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    // TO TEST:
    /*
     District Id : 009902
     Student Id : 31032068
     Start Code : BABOON
     
     Press Story button
     */
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.refreshButtons()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    // WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let middlePoint = self.view.frame.size.width / 2.0;
        webview?.frame = CGRect(x: 0, y: self.webViewOrigin(), width: middlePoint, height: self.webViewHeights());
        // Webview
        popupWebView = WKWebView(frame:CGRect(x:0, y:50, width:popupView!.frame.size.width, height:popupView!.frame.size.height) , configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        self.popupView?.addSubview(popupWebView!)
        view.addSubview(popupView!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == popupWebView {
            removePopUp()
        }
    }
    
    // Special Methods
    func removePopUp() {
        webview?.frame = CGRect(x: 0, y: self.webViewOrigin(), width: self.view.frame.size.width, height: webViewHeights())
        popupWebView?.loadHTMLString("<html/>", baseURL: nil)
        popupView?.removeFromSuperview()
    }
    
    func webViewHeights() -> CGFloat {
//        return self.view.frame.size.height - self.toolbar.frame.size.height;
        return self.view.frame.size.height;
    }
    
    func webViewOrigin() -> CGFloat {
//        return self.toolbar.frame.size.height;
        return 0.0;
    }
    
    @objc func closeButtonTapped() {
        self.removePopUp()
    }
    
    func preparePopUpWithConfiguration(configuration: WKWebViewConfiguration) {
        // Prepare WKWebview to use later
        let middlePoint = self.view.frame.size.width / 2.0;
        popupView = UIView(frame: CGRect(x: middlePoint, y: self.webViewOrigin(), width: middlePoint, height: self.webViewHeights()))
        
        // Toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: (popupView?.frame.size.width)!, height: 50))
        toolbar.barTintColor = UIColor(red: 112/255.0, green: 71/255.0, blue: 41/255.0, alpha: 1)
        toolbar.tintColor = UIColor.white
        toolbar.items = [UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeButtonTapped))]
        self.popupView?.addSubview(toolbar)
        
    }
    
    // View Controller Code
    var webview : WKWebView? =  nil;
    var popupView: UIView?
    var popupWebView: WKWebView?
//    @IBOutlet weak var toolbar: UIToolbar!
//    @IBOutlet weak var backButton: UIBarButtonItem!
//    @IBOutlet weak var fwdButton: UIBarButtonItem!
//    @IBAction func refreshButtonPressed(_ sender: Any) {
//        webview!.reload()
//        self.refreshButtons()
//    }
//    @IBAction func backButtonPressed(_ sender: Any) {
//        self.webview?.goBack()
//        self.refreshButtons()
//    }
//    @IBAction func forwardButtonPressed(_ sender: Any) {
//        self.webview?.goForward()
//        self.refreshButtons()
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func refreshButtons() {
        var backEnabled = false
        var forwardEnabled = false
        if self.webview?.canGoBack ?? false {
            backEnabled = true
        }
        if self.webview?.canGoForward ?? false {
            forwardEnabled = true;
        }
//        self.backButton.isEnabled = backEnabled
//        self.fwdButton.isEnabled = forwardEnabled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let configuration = WKWebViewConfiguration()
        
        configuration.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            configuration.mediaTypesRequiringUserActionForPlayback = .init(rawValue: 0)
        } else {
            // Fallback on earlier versions
            configuration.mediaPlaybackRequiresUserAction = true
        }
        
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        
        configuration.preferences = preferences
        
        

        webview = WKWebView(frame: CGRect(x: 0, y: self.webViewOrigin(), width: self.view.frame.size.width, height: self.view.frame.size.height), configuration: configuration)
        webview!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(webview!)
        self.view.sendSubviewToBack(webview!)
        let url = URLRequest(url: URL(string: "https://roamresearch.com/#/app/qb3l")!)
        webview?.navigationDelegate = self
        webview?.uiDelegate = self;
        webview!.load(url)
        
        
        preparePopUpWithConfiguration(configuration: configuration)
        
    }
    
    





}

