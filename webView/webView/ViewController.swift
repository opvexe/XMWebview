//
//  ViewController.swift
//  webView
//
//  Created by GDBank on 2017/9/5.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    fileprivate lazy var webView: UIWebView = {
        let webView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        webView.scrollView.delegate = self
        webView.scrollView.bounces = false
        webView.delegate = self
        webView.scalesPageToFit = true      ///MARK: 缩小至屏幕宽度
        webView.loadRequest(URLRequest.init(url: URL.init(string: "http://app.digitaling.com/articles/39581.html")!))
        return webView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.tableHeaderView = self.webView
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    deinit {
        print("释放内存")
    }
}

///MARK: UIWebViewDelegate  解决webView内存泄漏 一直剧增的问题
extension ViewController: UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UserDefaults.standard.set(0, forKey: "WebKitCacheModelPreferenceKey")
        UserDefaults.standard.set(false, forKey: "WebKitDiskImageCacheEnabled")
        UserDefaults.standard.set(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        UserDefaults.standard.synchronize()
    }
}
///MARK: WebviewDelegte
extension ViewController: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y == 0 {
            webView.scrollView.isScrollEnabled = true
        } else {
            webView.scrollView.isScrollEnabled = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y == 0 {
            webView.scrollView.isScrollEnabled = true
        } else {
            webView.scrollView.isScrollEnabled = false
        }
    }
}

///MARK: UITableViewDelegate && UITableViewDataSource
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ViewController.self))
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier:NSStringFromClass(ViewController.self))
        }
        
        cell?.textLabel?.text = "评论+" + String(indexPath.row + 1)
        return cell!
    }
}
