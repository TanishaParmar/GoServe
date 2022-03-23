//
//  Globals.swift
//  GoServe
//
//  Created by MyMac on 1/11/22.
//

import Foundation
import UIKit

struct Globals {
    
    static let defaults = UserDefaults.standard
    
    static var authToken: String{
      return defaults.value(forKey: DefaultKeys.authToken) as? String ?? "uid"
    }
    
    static var userId: String{
      return defaults.value(forKey: DefaultKeys.id) as? String ?? "uid"
    }
    
    static var deviceToken: String{
        return defaults.value(forKey: DefaultKeys.deviceToken) as? String ?? "529173FB75AC135EE09EE7186B98C89DBC72C2CC0EF25C242EA7DA31BD292EFC"
    }
    
    static var appleLoginResponse: String {
        return defaults.value(forKey: DefaultKeys.appleLoginResponse) as? String ?? ""
    }
    
//    @available(iOS 13.0, *)
//    static var appleLoginResponse: Data {
//        return defaults.value(forKey: DefaultKeys.appleLoginResponse) as! Data
//    }
    
    
    static func loginScreen() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier:"LogInVC") as! LogInVC
//        homeViewController.selectedIndex = 0
        let nav = UINavigationController(rootViewController: loginViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }

    
}
