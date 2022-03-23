//
//  NavigationManager.swift
//  GoServe
//
//  Created by Dharmani Apps on 23/12/21.
//

import Foundation
import UIKit

struct ICStoryboard {
    
    public static let main: String = "Main"
    public static let advisor: String = "Advisor"
    
}

struct SSNavigation {
    
    public static let signInOption: String = "navigationSingInOption"
}

class NavigationManager: NSObject {
    
//    let window = AppDelegate.shared.window
    
    //------------------------------------------------------
    
    //MARK: Storyboards
    
    let mainStoryboard = UIStoryboard(name: ICStoryboard.main, bundle: Bundle.main)
//    let advisorStoryboard = UIStoryboard(name:ICStoryboard.advisor, bundle: Bundle.main)
    //    let loaderStoryboard = UIStoryboard(name: SSStoryboard.loader, bundle: Bundle.main)
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static let shared = NavigationManager()
    
    //------------------------------------------------------
    
    //MARK: UINavigationController
    
    var signInOptionsNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: SSNavigation.signInOption) as! UINavigationController
    }
    
    //------------------------------------------------------
    
    //MARK: RootViewController
    
//    func setupSingInOption() {
//
//        let controller = signInOptionsNC
//        AppDelegate.shared.window?.rootViewController = controller
//        AppDelegate.shared.window?.makeKeyAndVisible()
//    }
    
    //------------------------------------------------------
    
    //MARK: UIViewControllers
 
    public var logInVC: LogInVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: LogInVC.self)) as! LogInVC
    }
    
    public var homeVC: HomeVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: HomeVC.self)) as! HomeVC
    }
    
    public var forgotPasswordVC: ForgotPasswordVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ForgotPasswordVC.self)) as! ForgotPasswordVC
    }
    public var signUpVC: SignUpVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SignUpVC.self)) as! SignUpVC
    }
    
    
    public var popUp: PopUpRatingVC{
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: PopUpRatingVC.self)) as! PopUpRatingVC
    }
    public var detail: OpportunityDetailVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: OpportunityDetailVC.self)) as! OpportunityDetailVC
    }
//    FilterVC
    public var filter: FilterVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: FilterVC.self)) as! FilterVC
    }
    
    public var editProfile: EditProfileVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: EditProfileVC.self)) as! EditProfileVC
    }
    public var setting: SettingVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SettingVC.self)) as! SettingVC
    }
  
    public var changePassword: ChangePasswordVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ChangePasswordVC.self)) as! ChangePasswordVC
    }
    
    public var organizationDetail: OrganizationDetailVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: OrganizationDetailVC.self)) as! OrganizationDetailVC
    }
    
    public var support: ReportAProblemVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ReportAProblemVC.self)) as! ReportAProblemVC
    }
    
    
    public var about: AboutGoServeVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: AboutGoServeVC.self)) as! AboutGoServeVC
    }
    
    public var privacy: PrivacyPolicyVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: PrivacyPolicyVC.self)) as! PrivacyPolicyVC
    }
    
    public var terms: TermsOfUseVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: TermsOfUseVC.self)) as! TermsOfUseVC
    }
    
    public var webViewVC: WebViewVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: WebViewVC.self)) as! WebViewVC
    }
    
//    TransactionVC
    
//    MARK: ADVISOR LOGIN
    
//    AdvisorForgotPasswordVC
 
    
    //
    //    public var prayVC: PrayVC {
    //        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: PrayVC.self)) as! PrayVC
    //    }
    
}



