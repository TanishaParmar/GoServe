//
//  WebViewVC.swift
//  GoServe
//
//  Created by MyMac on 1/25/22.
//

import UIKit
import WebKit

class WebViewVC: BaseVC {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        titleLabel.text = titleText
        var url = NSURL(string: WebLinks.aboutUsUrl)
        
        if titleText == "Privacy Policy" {
            url = NSURL(string: WebLinks.privacyPolicyUrl)

        } else if titleText == "Terms & Conditions" {
            url = NSURL(string: WebLinks.termsAndConditionUrl)
            
        } else if titleText == "About Us" {
            url = NSURL(string: WebLinks.aboutUsUrl)

        }
        let request = NSURLRequest(url: url! as URL)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.pop()
    }
    
   

}

extension WebViewVC:WKNavigationDelegate{

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
  }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    AFWrapperClass.svprogressHudDismiss(view: self)
  }

    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        showAlertMessage(title:AppAlertTitle.appName.rawValue, message: error.localizedDescription , okButton: "OK", controller: self) {
        }
    }
}
