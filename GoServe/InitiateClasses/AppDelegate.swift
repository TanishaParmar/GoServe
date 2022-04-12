//
//  AppDelegate.swift
//  GoServe
//
//  Created by Dharmani Apps on 31/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var organizationArr: [SelectOrganizationData]?
    
    private func configureKeboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIScrollView.self,UIView.self,UITextField.self,UITextView.self,UIStackView.self]
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(2)
        configureKeboard()
        // Override point for customization after application launch.
        getOrganizations()
        
        GIDSignIn.sharedInstance().clientID = "916708517998-jp0ku23bprlfute3ree5uh7nihsdes4c.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions) { (bloo, error) in
                    
                }
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("device token string", deviceTokenString)
        Globals.defaults.set(deviceTokenString, forKey: DefaultKeys.deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator :( \(error)")
    }
    
    func logOut(){
        GIDSignIn.sharedInstance()?.signOut()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignUpWithGmailandAppleVC") as! SignUpWithGmailandAppleVC
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func loginToHomePage() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier:"TabbarController") as! TabbarController
        homeViewController.selectedIndex = 0
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func moveToLogInScreen() {
        GIDSignIn.sharedInstance()?.signOut()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LogInViewController = mainStoryboard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        let nav = UINavigationController(rootViewController: LogInViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func loginScreen() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier:"TabbarController") as! TabbarController
        homeViewController.selectedIndex = 0
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func getOrganizations() {
        var organizationData : SelectOrganizationModel?
        
        let url = getFinalUrl(lastComponent: .getAllOrganizationForStudent)
        AFWrapperClass.requestPostWithMultiFormData(url, params: nil, headers: nil) { response in
            organizationData = self.getApiResponse(response: response)
            if let status = organizationData?.status {
                if status == 200 {
                    self.organizationArr = organizationData?.selectOrganizationData
                }
                else {
                }
            }
        } failure: { error in
            print(error)
        }
    }
    
    func getApiResponse(response: NSDictionary) -> SelectOrganizationModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let organizationData = try JSONDecoder().decode(SelectOrganizationModel.self, from: jsonData)
                return organizationData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
    func getOrganizationApiResponse(response: NSDictionary) -> OrganizationDetails? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let organizationData = try JSONDecoder().decode(OrganizationDetails.self, from: jsonData)
                return organizationData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
    func getOpportunityApiResponse(response: NSDictionary) -> OpportunitiesData? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let OpportunitiesData = try JSONDecoder().decode(OpportunitiesData.self, from: jsonData)
                return OpportunitiesData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
}


@available(iOS 12.0, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    print(dataObj)
                }
            }
            if UIApplication.shared.applicationState == .active {
                completionHandler( [.alert,.sound])
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any] {
            print(userInfo)
            
            let authToken  = getSAppDefault(key: DefaultKeys.authToken) as? String ?? ""
            if authToken != ""{
                print(authToken)
                if let apnsData = userInfo["aps"] as? [String:Any]{
                    if let dataObj = apnsData["data"] as? [String:Any]{
                        print(dataObj)
                        let notificationType = dataObj["notification_type"] as? String // apnsData["type"] as? String
                        let state = UIApplication.shared.applicationState
                        if state != .active {
                            
                            if notificationType == "2" || notificationType == "6" || notificationType == "12" || notificationType == "13" || notificationType == "14" {
                                
                                let homeVC = NavigationManager.shared.homeVC
                                homeVC.notificationData = dataObj
                                homeVC.isPushNotify = true
                                
                                let storyBoard = UIStoryboard.init(name:"Main", bundle: nil)
                                let rootVc = storyBoard.instantiateViewController(withIdentifier:"TabbarController") as! TabbarController

                                let navVC = rootVc.viewControllers![0] as? HomeVC

                                navVC?.isPushNotify = true
                                navVC?.notificationData = dataObj
                                rootVc.selectedIndex = 0

                                let nav =  UINavigationController(rootViewController: rootVc)
                                nav.isNavigationBarHidden = true


                                if #available(iOS 13.0, *){
                                    if let scene = UIApplication.shared.connectedScenes.first {
                                        let windowScene = (scene as? UIWindowScene)
                                        print(">>> windowScene: \(windowScene)")
                                        let window: UIWindow = UIWindow(frame: (windowScene?.coordinateSpace.bounds)!)
                                        window.windowScene = windowScene //Make sure to do this
                                        window.rootViewController = nav
                                        window.makeKeyAndVisible()
                                        self.window = window
                                    }
                                } else {
                                    self.window?.rootViewController = nav
                                    self.window?.makeKeyAndVisible()
                                }
                            }
//                            else if notificationType == "2"{
//                                let storyBoard = UIStoryboard.init(name:"Main", bundle: nil)
//                                let rootVc = storyBoard.instantiateViewController(withIdentifier:"OrganizationDetailVC") as! OrganizationDetailVC
////                                rootVc.selectedIndex = 1
//                                let orgData = dataObj["organizationDetails"] as? NSDictionary
//                                let orgDetails = getOrganizationApiResponse(response: orgData!)
//                                print(orgDetails)
//                                rootVc.orgDetails = orgDetails
//                                let nav =  UINavigationController(rootViewController: rootVc)
//                                nav.isNavigationBarHidden = true
//                                if #available(iOS 13.0, *){
//                                    if let scene = UIApplication.shared.connectedScenes.first {
//                                        let windowScene = (scene as? UIWindowScene)
//                                        print(">>> windowScene: \(windowScene)")
//                                        let window: UIWindow = UIWindow(frame: (windowScene?.coordinateSpace.bounds)!)
//                                        window.windowScene = windowScene //Make sure to do this
//                                        window.rootViewController = nav
//                                        window.makeKeyAndVisible()
//                                        self.window = window
//                                    }
//                                } else {
//                                    self.window?.rootViewController = nav
//                                    self.window?.makeKeyAndVisible()
//                                }
//                            }
//                            else if notificationType == "6" || notificationType == "12" || notificationType == "13" || notificationType == "14" {
//                                let storyBoard = UIStoryboard.init(name:"Main", bundle: nil)
//                                let rootVc = storyBoard.instantiateViewController(withIdentifier:"OpportunityDetailVC") as! OpportunityDetailVC
//                                //                                rootVc.selectedIndex = 1
//                                let oppData = dataObj["opportunityDetails"] as? NSDictionary
//                                let oppDetails = getOpportunityApiResponse(response: oppData!)
//                                print(oppDetails)
//                                rootVc.opportunitiesData = oppDetails
//                                rootVc.isFromUpcomingPast = true
//                                let nav =  UINavigationController(rootViewController: rootVc)
//                                nav.isNavigationBarHidden = true
//                                if #available(iOS 13.0, *) {
//                                    if let scene = UIApplication.shared.connectedScenes.first {
//                                        let windowScene = (scene as? UIWindowScene)
//                                        print(">>> windowScene: \(windowScene)")
//                                        let window: UIWindow = UIWindow(frame: (windowScene?.coordinateSpace.bounds)!)
//                                        window.windowScene = windowScene //Make sure to do this
//                                        window.rootViewController = nav
//                                        window.makeKeyAndVisible()
//                                        self.window = window
//                                    }
//                                } else {
//                                    self.window?.rootViewController = nav
//                                    self.window?.makeKeyAndVisible()
//                                }
//                            }
                            else {
                                let storyBoard = UIStoryboard.init(name:"Main", bundle: nil)
                                let rootVc = storyBoard.instantiateViewController(withIdentifier:"TabbarController") as! TabbarController
                                rootVc.selectedIndex = 1
                                
                                let nav =  UINavigationController(rootViewController: rootVc)
                                nav.isNavigationBarHidden = true
                                if #available(iOS 13.0, *){
                                    if let scene = UIApplication.shared.connectedScenes.first{
                                        let windowScene = (scene as? UIWindowScene)
                                        print(">>> windowScene: \(windowScene)")
                                        let window: UIWindow = UIWindow(frame: (windowScene?.coordinateSpace.bounds)!)
                                        window.windowScene = windowScene //Make sure to do this
                                        window.rootViewController = nav
                                        window.makeKeyAndVisible()
                                        self.window = window
                                    }
                                } else {
                                    self.window?.rootViewController = nav
                                    self.window?.makeKeyAndVisible()
                                }
                            }
                            
                        }
                        else {
                            print("foreground notification")
//                            if notificationType == "2" || notificationType == "6" || notificationType == "12" || notificationType == "13" || notificationType == "14" {
//                                if let topVC = UIApplication.topViewController() {
//
//                                }
//                            }
                            
                            if notificationType == "2" {  // org
                                let oppData = dataObj["organizationDetails"] as? NSDictionary
                                let oppDetails = getOrganizationApiResponse(response: oppData!)
                                print(oppDetails)
                                
                                if let topVC = UIApplication.getTopViewController() {
                                    let controller = NavigationManager.shared.organizationDetail
                                    controller.orgDetails = oppDetails
//                                    topVC.navigationController.push(controller: controller, animated: true)
                                    topVC.navigationController?.pushViewController(controller, animated: true)
                                }
                                
//                                let orgData = notificationData?["organizationDetails"] as? NSDictionary
//                                let orgDetails = getOrganizationApiResponse(response: orgData!)
//                                let controller = NavigationManager.shared.organizationDetail
//                                controller.orgDetails = orgDetails
//                                self.push(controller: controller, animated: true)
                            }
                            else if notificationType == "6" || notificationType == "12" || notificationType == "13" || notificationType == "14" { // opp
                                let oppData = dataObj["opportunityDetails"] as? NSDictionary
                                let oppDetails = getOpportunityApiResponse(response: oppData!)
                                print(oppDetails)
                                if let topVC = UIApplication.getTopViewController() {
                                    let controller = NavigationManager.shared.detail
                                    controller.opportunitiesData = oppDetails
                                    controller.isFromUpcomingPast = true
//                                    topVC.navigationController.push(controller: controller, animated: true)
                                    topVC.navigationController?.pushViewController(controller, animated: true)
                                }
//                                let oppData = notificationData?["opportunityDetails"] as? NSDictionary
//                                let oppDetails = getOpportunityApiResponse(response: oppData!)
//                                let controller = NavigationManager.shared.detail
//                                controller.opportunitiesData = oppDetails
//                                controller.isFromUpcomingPast = true
//                                self.push(controller: controller, animated: true)
                            }
                        }
                    }
                }
            }else{
                moveToLogInScreen()
                //                completionHandler()
                print("not working")
            }
        }
        completionHandler()
    }
    
    func convertStringToDictionary(json: String) -> [String: AnyObject]? {
        if let data = json.data(using: String.Encoding.utf8) {
            let json = try? JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String: AnyObject]
            // if let error = error {
            // print(error!)
            //}
            return json!
        }
        return nil
    }
    
}


extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                //                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        } else {
            debugPrint("user info =>", user?.profile)
        }
        
        // Post notification after user successfully sign in
        NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil, userInfo: ["googleUserInfo": user])
    }
}

// MARK:- Notification names
extension Notification.Name {
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
