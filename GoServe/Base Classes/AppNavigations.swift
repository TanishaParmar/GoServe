//
//  AppNavigations.swift
//  GoServe
//
//  Created by Dharmani Apps on 23/12/21.
//

import Foundation
import UIKit

class Navigation {
    open var pushCallBack = { (identifier:String,storyBoardName:String,class:UIViewController,storyboard:UIStoryboard,navigationVC:UINavigationController) -> () in
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        navigationVC.pushViewController(vc, animated: true)
        return
    }
}

