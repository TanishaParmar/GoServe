//
//  BaseVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 23/12/21.
//

import UIKit
class BaseVC : UIViewController, UIGestureRecognizerDelegate {
    
    //    var currentUser: UserModal? {
    //        return PreferenceManager.shared.currentUserModal
    //    }
    
    //    var currentUserHost: HostModal? {
    //        return PreferenceManager.shared.currentUserModalForHost
    //    }
    
    //    var currentStudioUser : StudioUserModal?{
    //        return PreferenceManager.shared.currentStudioUserModal
    //    }
    //
    //    var favUnfavModal : AddFavUnfavModal?{
    //        return PreferenceManager.shared.addRemoveFav
    //    }
    //
    //    var studioDetail : StudioModel? {
    //        return PreferenceManager.shared.studioDetails
    //    }
    //
    //    var sessionDetail : BookingSessionModal? {
    //        return PreferenceManager.shared.sessionDetails
    //    }
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    public func push(controller: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    public func pushWithHandler(controller: UIViewController, animated: Bool = true , complition : @escaping () -> Void  ) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    public func pop(animated: Bool = true) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    public func poptoLogin(controller: UIViewController,animated: Bool = true){
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    
    public func pushWithoutAnimate(controller: UIViewController, animated: Bool = false) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    public func popWithoutAnimate(animated: Bool = false) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    // pop back n viewcontroller
    public func popBack(_ nb: Int) {
        DispatchQueue.main.async {
            if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
                guard viewControllers.count < nb else {
                    self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: false)
                    return
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //    func handleError(code: Int?) {
    //
    //        if code == 105 {
    //
    //            let message = localized(code: code ?? 0)
    //            DisplayAlertManager.shared.displayAlert(animated: true, message: message, handlerOK: {
    //                //NavigationManager.shared.setupSingInOption()
    //            })
    //
    //        } else {
    //
    //            let message = localized(code: code ?? 0)
    //            DisplayAlertManager.shared.displayAlert(animated: true, message: message, handlerOK: nil)
    //        }
    //
    //    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.view.backgroundColor = FGColor.appBlack
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}

