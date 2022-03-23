//
//  LogInVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 23/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import AuthenticationServices

class LogInVC: BaseVC,UITextFieldDelegate,UITextViewDelegate {
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var iconClick = true
    
    //    MARK: OUTLETS
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var seenUnseenBtn: UIButton!
    @IBOutlet weak var rememberbtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var seenUnseenImg: UIImageView!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var rememberMeImg: UIImageView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var headerlbl: UILabel!
    
    var rememberMeSelected = false
    var gType = 0
    var userDict: GIDGoogleUser?
    var appleLoginArr: [String.SubSequence]? = nil
    var signUpResponse: SignupResponseData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(userDidSignInGoogle(_:)), name: .signInGoogleCompleted, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .signInGoogleCompleted, object: nil)
    }
    
    //    MARK: UIBUTTONS ACTION
    @IBAction func loginBtn(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func forgotBtn(_ sender: UIButton) {
        let controller = NavigationManager.shared.forgotPasswordVC
        self.push(controller: controller, animated: true)
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        let controller = NavigationManager.shared.signUpVC
        self.push(controller: controller, animated: true)
    }
    
    @IBAction func seenUnseenBtn(_ sender: UIButton) {
        if(iconClick == true) {
            passwordTF.isSecureTextEntry = false
            seenUnseenImg.image = UIImage(named:"ey")
            seenUnseenImg.contentMode = .scaleAspectFit
            
        } else {
            passwordTF.isSecureTextEntry = true
            seenUnseenImg.image = UIImage(named: "eye")
            seenUnseenImg.contentMode = .scaleAspectFit
        }
        iconClick = !iconClick
    }
    
    @IBAction func rememberBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.rememberMeSelected = sender.isSelected
        if(iconClick == true) {
            rememberMeImg.image = UIImage(named:"check")
            rememberMeImg.contentMode = .scaleAspectFit
            
        } else {
            rememberMeImg.image = UIImage(named: "uncheck")
            rememberMeImg.contentMode = .scaleAspectFit
        }
        if !rememberMeSelected{
            removeAppDefaults(key: "userEmail")
            removeAppDefaults(key: "userPassword")
        }
        iconClick = !iconClick
    }
    
    @IBAction func googleBtn(_ sender: UIButton) {
        gType = 1
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    @IBAction func appleBtn(_ sender: UIButton) {
        gType = 2
        loginWithAppleButtonPressed()
    }
    
    //    MARK: FUNCTIONS
    func uiConfigure() {
        emailTF.delegate = self
        passwordTF.delegate = self
        emailTF.text = self.getEmail()
        passwordTF.text = self.getPassword()
        rememberMeImg.image = self.checkIsRemember() ? UIImage(named: "check") : UIImage(named: "uncheck")
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        googleView.layer.applySketchShadow(y:0)
        appleView.layer.applySketchShadow(y:0)
        let text = "Ready to Serve Again ?"
        let attributedText = text.setColor( #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1) , ofSubstring: "Serve")
        let myLabel = headerlbl
        myLabel!.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        myLabel!.attributedText = attributedText
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //        NotificationCenter.default.addObserver(self,selector: #selector(userDidSignInGoogle(_:)), name: .signInGoogleCompleted, object: nil)
    }
    
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        if let dict = notification.userInfo?["googleUserInfo"] as? GIDGoogleUser {
            print("dict =>", dict)
            userDict = dict
            hitCompareUserTokenApi()
            //            controller.googleUser = dict
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
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingCompareTokenParams(), headers: nil) { response in
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
    
    func generatingCompareTokenParams() -> [String:Any] {
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
                            self.navigateToTabBar()
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
                        //                        setAppDefaults(signUpResponse?.signupResponseData?.authToken, key: DefaultKeys.authToken)
                        //                        self.navigateToLogInVC()
                        if let data = googleLogInResponse?.signupResponseData {
                            setAppDefaults(data.authToken, key: DefaultKeys.authToken)
                            self.navigateToTabBar()
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
    
    func hitLoginApi() {
        var logInResponse : SignupResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .logIn)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            logInResponse = self.getApiResponse(response: response)
            let message = logInResponse?.message  // loginResp?.alertMessage ?? ""
            if let status = logInResponse?.status { // loginResp?.status {
                if status == 200 {
                    if self.rememberMeSelected == true {
                        storeCredential(username: self.emailTF.text!, password: self.passwordTF.text!, isRemember: true)
                    } else {
                        removeCredential()
                    }
                    if let data = logInResponse?.signupResponseData {
                        setAppDefaults(data.authToken, key: DefaultKeys.authToken)
                        self.navigateToTabBar()
                    }
                    //}
                } else if status == 403 {
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
//                        Globals.loginScreen()
                    }
                } else {
                    alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
                }
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(error)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    func generatingParams() -> [String:Any] {
        var params : [String:Any] = [:]
        params["email"] = emailTF.text
        params["password"] = passwordTF.text
        params["deviceToken"] = Globals.deviceToken
        params["deviceType"] = "1"
        print("params =>", params)
        return params
    }
    
    func navigateToTabBar() {
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
    
    func getEmail() -> String {
        if let email =  UserDefaults.standard.value(forKey:"username") {
            //            rememberMeSelected = true
            return email as! String
        } else {
            //            rememberMeSelected = false
            return ""
        }
    }
    
    func getPassword() -> String {
        if let password =  UserDefaults.standard.value(forKey:"password") {
            //            rememberMeSelected = true
            return password as! String
        } else {
            //            rememberMeSelected = false
            return ""
        }
    }
    
    func checkIsRemember() -> Bool {
        if let isRemember = UserDefaults.standard.value(forKey: "rememberPassword") {
            rememberMeSelected = isRemember as! Bool
        } else {
            rememberMeSelected = false
        }
        return rememberMeSelected
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.layer.borderColor = textField == emailTF ?  #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.layer.borderColor = textField == passwordTF ?  #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //  MARK: VALIDATIONS
    func validation() {
        if (emailTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter email." , okButton: "Ok", controller: self) {
            }
        }else if emailTF.text!.isValidEmail == false{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter vaild email." , okButton: "Ok", controller: self) {
            }
        }else if (passwordTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter password." , okButton: "Ok", controller: self) {
            }
        }else if (passwordTF!.text!.count) < 6 || (passwordTF!.text!.count) > 15 {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Password should be minimum 6 digits." , okButton: "Ok", controller: self) {
            }
        }
        else {
            //            navigateToTabBar()
            hitLoginApi()
        }
    }
    
}


@available(iOS 13.0, *)
extension LogInVC: ASAuthorizationControllerDelegate {
    
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
extension LogInVC: ASAuthorizationControllerPresentationContextProviding {
    
    //For present window
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
        
    }
    
}


extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.3,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

public extension String {
    func setColor(_ color: UIColor, ofSubstring substring: String) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: substring)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return attributedString
    }
}
extension String{
    var trimWhiteSpace: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
