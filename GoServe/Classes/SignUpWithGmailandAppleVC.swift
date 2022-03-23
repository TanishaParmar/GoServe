//
//  SignUpWithGmailandAppleVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 24/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import AuthenticationServices

class SignUpWithGmailandAppleVC: BaseVC {

//    MARK: OUTLETS
    
    @IBOutlet weak var signUpWithEmailBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var appleView: UIView!
    
    var gType: Int?
    var userDict: GIDGoogleUser?
    var appleLoginArr: [String.SubSequence]? = nil
    var signUpResponse: SignupResponseData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleView.layer.applySketchShadow(y:0)
        appleView.layer.applySketchShadow(y:0)
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(userDidSignInGoogle(_:)), name: .signInGoogleCompleted, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .signInGoogleCompleted, object: nil)
    }
        
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        print("notification =>", notification)
        if let dict = notification.userInfo?["googleUserInfo"] as? GIDGoogleUser {
            print("dict =>", dict)
            userDict = dict
            hitCompareUserTokenApi()
        }
    }

    func loginWithAppleButtonPressed() {
        if #available(iOS 13.0, *) {
            let appleSignInRequest = ASAuthorizationAppleIDProvider().createRequest()
            appleSignInRequest.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [appleSignInRequest])
            controller.delegate = self
            controller.presentationContextProvider = self
            
            controller.performRequests()
            
        } else {
            //            self.Alert(message:KeyMessages.shared.kAppleLoginAvailability)
        }
    }
    
    
    func hitCompareUserTokenApi() {
        var googleLogInResponse : SignupResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .checkGoogleAppleTokenExistsByType)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            googleLogInResponse = self.getApiResponse(response: response)
//            let message = googleLogInResponse?.message  // loginResp?.alertMessage ?? ""
            if let status = googleLogInResponse?.status { // loginResp?.status {
                if status == 200 {
                    if self.userDict != nil {
                        self.signUpResponse = googleLogInResponse?.signupResponseData
                        self.hitGoogleLoginApi()
                    } else if self.appleLoginArr != nil {
                        self.signUpResponse = googleLogInResponse?.signupResponseData
                        self.hitAppleLoginApi()
                    }
                } else {
                    self.navigateToSignUpVC()
                    //                    alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
                }
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    func generatingParams() -> [String:Any] {
//        guard let userData = userDict else { return [:] }
//        guard var token = userData.userID else { return [:] }
        
        var params : [String:Any] = [:]

        if let userData = userDict {
            if let token = userData.userID {
                params["type"] = gType
                params["token"] = token
                print("params =>", params)
                return params
            }
        }
        else if let data = appleLoginArr {
            if data.count > 1 {
                let id = String(data[3])
                params["token"] = id
            } else {
                params["token"] = String(data[0])
            }
            params["type"] = gType
            print("params =>", params)
            return params
        }
        return [:]
    }

    func getApiResponse(response: NSDictionary) -> SignupResponseModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: [])
        {
            do {
                let loginData = try JSONDecoder().decode(SignupResponseModel.self, from: jsonData)
                return loginData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
    
    //MARK: Google Login Api
    func hitGoogleLoginApi() {
        var googleLogInResponse : SignupResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .googleLogin)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingGoogleLoginParams(), headers: nil) { response in
            print("response is =>", response)
            AFWrapperClass.svprogressHudDismiss(view: self)

            googleLogInResponse = self.getApiResponse(response: response)
            let message = googleLogInResponse?.message // response["message"] as? String ?? ""
            if let status = googleLogInResponse?.status { // response["status"] as? Int {
                if status == 200{
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        if let data = googleLogInResponse?.signupResponseData {
                            setAppDefaults(data.authToken, key: DefaultKeys.authToken)
                            self.navigateToTabBarVC()
                        }

                    }
                } else {
                    alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
                }
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
 
    func generatingGoogleLoginParams() ->[String : Any] {
        var params : [String:Any] = [:]
        if let googleResponse = signUpResponse {
            params["firstName"] = googleResponse.firstName
            params["lastName"] = googleResponse.lastName
            params["userName"] = googleResponse.userName
            params["email"] = googleResponse.email
            params["googleToken"] = googleResponse.googleToken
            params["googleImage"] = googleResponse.profileImage
            params["deviceToken"] = Globals.deviceToken
            params["dob"] = googleResponse.dob
            params["orgID"] = googleResponse.orgID
            params["deviceType"] = "1"
            print("params =>", params)
        }
        return params
    }
    
    //MARK: APPLe Login Api
    func hitAppleLoginApi() {
        var appleLogInResponse : SignupResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .appleLogin)
       
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingAppleLoginParams(), headers: nil) { response in
            print("response is =>", response)
            AFWrapperClass.svprogressHudDismiss(view: self)

            appleLogInResponse = self.getApiResponse(response: response)
            let message = appleLogInResponse?.message // response["message"] as? String ?? ""
            if let status = appleLogInResponse?.status { // response["status"] as? Int {
                if status == 200{
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        if let data = appleLogInResponse?.signupResponseData {
                            setAppDefaults(data.authToken, key: DefaultKeys.authToken)
                            self.navigateToTabBarVC()
                        }
                    }
                } else {
                    alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
                }
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        
    }
    
    
       func generatingAppleLoginParams() ->[String : Any] {
           var params : [String:Any] = [:]
           if let googleResponse = signUpResponse {
               params["firstName"] = googleResponse.firstName
               params["lastName"] = googleResponse.lastName
               params["userName"] = googleResponse.userName
               params["email"] = googleResponse.email
               params["appleToken"] = googleResponse.appleToken
               params["appleImage"] = googleResponse.profileImage
               params["deviceToken"] = Globals.deviceToken
               params["dob"] = googleResponse.dob
               params["orgID"] = googleResponse.orgID
               params["deviceType"] = "1"
               print("params =>", params)
           }
           return params
       }

 
        
    func navigateToTabBarVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier:"TabbarController") as? TabbarController
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToSignUpVC() {
        let controller = NavigationManager.shared.signUpVC
        if userDict != nil {
            controller.googleUser = userDict
        } else if appleLoginArr != nil {
            controller.appleLoginResponse = appleLoginArr
        }
        self.push(controller: controller, animated: true)
    }
    
    
    @IBAction func signInBtn(_ sender: UIButton) {
        let controller = NavigationManager.shared.logInVC
        self.push(controller: controller, animated: true)
    }
    
    @IBAction func googleBtn(_ sender: UIButton) {
        gType = 1
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func appleBtn(_ sender: UIButton) {
        gType = 2
        loginWithAppleButtonPressed()
    }
    
    @IBAction func signUpWithEmailBtn(_ sender: UIButton) {
        let controller = NavigationManager.shared.signUpVC
        self.push(controller: controller, animated: true)
    }
}


@available(iOS 13.0, *)
extension SignUpWithGmailandAppleVC: ASAuthorizationControllerDelegate {

     // ASAuthorizationControllerDelegate function for authorization failed

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }

       // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("apple id credentials are =>", appleIDCredential)
            
            let name = appleIDCredential.fullName?.givenName ?? ""
            let lastName = appleIDCredential.fullName?.familyName ?? ""
            let email = appleIDCredential.email ?? ""
            let token = appleIDCredential.user
            
            
            
            let details = [name,lastName,email,token]
            let mailname = details.joined(separator: ",")
            
            Globals.defaults.set(mailname, forKey: DefaultKeys.appleLoginResponse)
            
            let loginDetails = Globals.appleLoginResponse
            appleLoginArr = loginDetails.split {$0 == ","}
            hitCompareUserTokenApi()
//            let controller = NavigationManager.shared.signUpVC
//            controller.appleLoginResponse = fullNameArr
//            self.push(controller: controller, animated: true)
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            print("password credentials are =>", passwordCredential)
        }

    }

}

@available(iOS 13.0, *)
extension SignUpWithGmailandAppleVC: ASAuthorizationControllerPresentationContextProviding {

    //For present window

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return self.view.window!

    }

}
