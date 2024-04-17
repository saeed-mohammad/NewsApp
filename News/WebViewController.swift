//
//  WebViewController.swift
//  News
//
//  Created by saeed shaikh on 4/17/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the URL in the web view
        guard let url = url else{
            print("Error: URL is nil")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
