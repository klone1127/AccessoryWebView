//
//  ViewController.swift
//  WebViewAccessoryView
//
//  Created by CF on 2018/5/29.
//  Copyright © 2018年 klone. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    var webView: FA_InputAccessoryWebView?
    var webView_category: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webviewAccessory()
//        webviewAccessoryViewWithCategory()
    }
    
    /// 使用继承的方式
    func webviewAccessory() {
        webView = FA_InputAccessoryWebView(frame: view.bounds)
        view.addSubview(webView!)
        webView?.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com")!))
        webView?.changeAccessoryView(accessoryView())
    }
    
    /// 使用category
    func webviewAccessoryViewWithCategory() {
        webView_category = UIWebView(frame: view.bounds)
        view.addSubview(webView_category!)
        
        webView_category?.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com")!))
        webView_category?.delegate = self
        webView_category?.k_AccessoryView = accessoryView()
    }
    
    func accessoryView() -> UIView {
        let tempAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        tempAccessoryView.backgroundColor = .red
        return tempAccessoryView
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("start: ----------------------------\n")
        print(webView)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("resuest:\n \(request)")
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("error:\n \(error)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

