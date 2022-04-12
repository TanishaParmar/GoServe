//
//  SignUpVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 24/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import AuthenticationServices

class SignUpVC: BaseVC,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
//    MARK: VARIABLES
    let datePicker = UIDatePicker()
    var iconClick = false
    var picker  = UIPickerView()
    var toolBar = UIToolbar()
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
//    var organizationArr : [String] = ["MIT","College","World Health Organization","World Trade Organization","UNICEF","Washington, DC"]
    var selectedOption: String? {
         didSet {
             self.organizationTF.text = selectedOption
         }
     }
    
    var appleLoginResponse: [String.SubSequence]?
    var organizationArr : [SelectOrganizationData]?
    var orgID : String?
    var googleUser: GIDGoogleUser?
    var googleToken: String?
    var googleImg: String?


    
//    MARK: OUTLETS
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var chooseUserNameView: UIView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var birthdayDateView: UIView!
    @IBOutlet weak var birthdayDateTF: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var passwordSeenUnseenBtn: UIButton!
    @IBOutlet weak var confirmPasswordSeenUnseenBtn: UIButton!
    @IBOutlet weak var imgViewAgreeBtn: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var organizationView: UIView!
    @IBOutlet weak var organizationTF: UITextField!
//    @IBOutlet weak var organizationPickerView: UIPickerView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var emailSuperView: UIView!
    @IBOutlet weak var passwordSuperView: UIView!
    @IBOutlet weak var confirmPasswordSuperView: UIView!
    @IBOutlet weak var organizationSuperView: UIView!
    @IBOutlet weak var dobView: UIView!
    
    
    var serve = "Ready to Serve Again"
    let pickerView = UIPickerView()
    var isPasswordShow = true
    var isConfirmPasswordShow = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if googleUser != nil {
            setUpGoogleLoginUI()
        } else if appleLoginResponse != nil {
            setUpAppleLoginUI()
        }
        organizationData()
        uiUpdate()
        createDatePicker()
    }
    
    func setUpGoogleLoginUI() {
        passwordSuperView.isHidden = true
        confirmPasswordSuperView.isHidden = true
        if let userData = googleUser {
            if let userProfile = userData.profile {
                emailTF.text = userProfile.email
                firstnameTF.text = userProfile.givenName
                lastNameTF.text = userProfile.familyName
                usernameTF.text = userProfile.name
                googleImg = userProfile.imageURL(withDimension: 500).absoluteString
            }
            if let token = userData.userID {
                googleToken = token
            }
        }
    }
    
    func setUpAppleLoginUI() {
        passwordSuperView.isHidden = true
        confirmPasswordSuperView.isHidden = true
        let details = Globals.appleLoginResponse    // KeychainWrapper.standard.string(forKey: "saveApple")
        let fullNameArr = details.split {$0 == ","}
        let nameString = String(fullNameArr[0])
        let lastName = String(fullNameArr[1])
        let emailString = String(fullNameArr[2])
        let token = String(fullNameArr[3])
        
        firstnameTF.text = nameString
        lastNameTF.text = lastName
        emailTF.text = emailString
        googleToken = token
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func googleBtn(_ sender: UIButton) {
        
    }
    @IBAction func appleBtn(_ sender: UIButton) {
    
    }
    @IBAction func signInBtn(_ sender: UIButton) {
        self.pop()
    }
    @IBAction func agreeWithbtn(_ sender: UIButton) {
        iconClick = !iconClick
        if iconClick {
            imgViewAgreeBtn.image = UIImage(named:"check")
            imgViewAgreeBtn.contentMode = .scaleAspectFit
        } else {
            imgViewAgreeBtn.image = UIImage(named: "uncheck")
            imgViewAgreeBtn.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func termsAndConditionBtn(_ sender: UIButton) {
        let controller = NavigationManager.shared.webViewVC
        controller.titleText = "Terms & Conditions"
        self.push(controller: controller, animated: true)
    }
    
    @IBAction func passwordSeenUnseenBtnAction(_ sender: Any) {
        if(isPasswordShow == true) {
            passwordTF.isSecureTextEntry = false
            passwordImageView.image = UIImage(named:"ey")
            passwordImageView.contentMode = .scaleAspectFit

        } else {
            passwordTF.isSecureTextEntry = true
            passwordImageView.image = UIImage(named: "eye")
            passwordImageView.contentMode = .scaleAspectFit
        }
        isPasswordShow = !isPasswordShow
    }
    
        
    @IBAction func confirmPasswordSeenUnseenBtnAction(_ sender: Any) {
        if(isConfirmPasswordShow == true) {
            confirmPasswordTF.isSecureTextEntry = false
            confirmPasswordImageView.image = UIImage(named:"ey")
            confirmPasswordImageView.contentMode = .scaleAspectFit

        } else {
            confirmPasswordTF.isSecureTextEntry = true
            confirmPasswordImageView.image = UIImage(named: "eye")
            confirmPasswordImageView.contentMode = .scaleAspectFit
        }
        isConfirmPasswordShow = !isConfirmPasswordShow
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        birthdayDateTF.inputAccessoryView = toolbar
        let calendar = Calendar.current
        let backDate = calendar.date(byAdding: .year, value: -15, to: Date())
        datePicker.locale = NSLocale(localeIdentifier: "en_US") as Locale // 24 hour time
        datePicker.timeZone = TimeZone(identifier: "UTC")
        datePicker.maximumDate = backDate
        birthdayDateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MM/dd/yyyy"
        birthdayDateTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func createPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        organizationTF.inputAccessoryView = toolBar
        organizationTF.inputView = pickerView
    }
    
    
    @objc func action() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        organizationTF.text = organizationArr?[row].orgTitle
        self.orgID = self.organizationArr?[row].orgID
        view.endEditing(true)
    }
    
    
    func uiUpdate() {
        firstnameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        usernameTF.delegate = self
        passwordTF.delegate = self
        organizationTF.delegate = self
        confirmPasswordTF.delegate = self
        birthdayDateTF.delegate = self
        firstNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        chooseUserNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        confirmPasswordView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        birthdayDateView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        organizationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        googleView.layer.applySketchShadow(y:0)
        appleView.layer.applySketchShadow(y:0)
        let text = "Create An Account"
        let attributedText = text.setColor( #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1) , ofSubstring: "Create")
        let myLabel = titleLbl
        myLabel!.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        myLabel!.attributedText = attributedText
    }
    
    func organizationData() {
        if #available(iOS 13.0, *) {
            self.organizationArr = appDel.organizationArr
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
    func hitSignUpApi() {
        var signUpResponse : SignupResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .signUp)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)

            signUpResponse = self.getApiResponse(response: response)
            let message = signUpResponse?.message // response["message"] as? String ?? ""
            if let status = signUpResponse?.status { // response["status"] as? Int {
                if status == 200{
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
//                        setAppDefaults(signUpResponse?.signupResponseData?.authToken, key: DefaultKeys.authToken)
                        self.navigateToLogInVC()
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
 
    func generatingParams() ->[String : Any] {
        var params : [String:Any] = [:]
        params["firstName"] = firstnameTF.text
        params["lastName"] = lastNameTF.text
        params["userName"] = usernameTF.text
        params["email"] = emailTF.text
        params["password"] = passwordTF.text
        params["dob"] = birthdayDateTF.text
        params["deviceToken"] = Globals.deviceToken
        params["orgID"] = self.orgID
        params["deviceType"] = "1"
        print("params =>", params)
        return params
    }
    
    func getApiResponse(response: NSDictionary) -> SignupResponseModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: [])
        {
            do {
                let loginData = try JSONDecoder().decode(SignupResponseModel.self, from: jsonData)
                print("JSON", loginData)
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
        params["firstName"] = firstnameTF.text
        params["lastName"] = lastNameTF.text
        params["userName"] = usernameTF.text
        params["email"] = emailTF.text
        params["googleToken"] = googleToken
        params["googleImage"] = googleImg
        params["deviceToken"] = Globals.deviceToken
        params["dob"] = birthdayDateTF.text
        params["orgID"] = self.orgID
        params["deviceType"] = "1"
        print("params =>", params)
        return params
    }
    
    //MARK: Google Login Api
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
        params["firstName"] = firstnameTF.text
        params["lastName"] = lastNameTF.text
        params["userName"] = usernameTF.text
        params["email"] = emailTF.text
        params["appleToken"] = googleToken
        params["appleImage"] = googleImg
        params["deviceToken"] = Globals.deviceToken
        params["dob"] = birthdayDateTF.text
        params["orgID"] = self.orgID
        params["deviceType"] = "1"
        print("params =>", params)
        return params
    }

//    func getGoogleLoginApiResponse(response: NSDictionary) -> SignupResponseModel? {
//        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: [])
//        {
//            do {
//                let loginData = try JSONDecoder().decode(SignupResponseModel.self, from: jsonData)
//                print("JSON", loginData)
//                return loginData
//            } catch {
//                print("ERROR:", error)
//                return nil
//            }
//        }
//        return nil
//    }

    
    func navigateToLogInVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier:"LogInVC") as? LogInVC
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToTabBar() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier:"TabbarController") as? TabbarController
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = textField == firstnameTF ?  #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameView.layer.borderColor = textField == lastNameTF ?  #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.layer.borderColor = textField == emailTF ?  #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        chooseUserNameView.layer.borderColor = textField == usernameTF ?  #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.layer.borderColor = textField == passwordTF ?  #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        confirmPasswordView.layer.borderColor = textField == confirmPasswordTF ?  #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        birthdayDateView.layer.borderColor = textField == birthdayDateTF ?  #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        organizationView.layer.borderColor = textField == organizationTF ?  #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        createPickerView()
        if textField == self.organizationTF {
            createPickerView()
//            self.organizationPickerView.isHidden = false
////            self.view.endEditing(true)
//            organizationTF.endEditing(true)
        }
//            else {
//            self.organizationPickerView.isHidden = true
//        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        chooseUserNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        confirmPasswordView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        birthdayDateView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        organizationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //   MARK: VALIDATIONS
    func validation() {
        if (firstnameTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter first name." , okButton: "Ok", controller: self) {
            }
        }
        else if (lastNameTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter last name." , okButton: "Ok", controller: self) {
            }
        }else if (emailTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter email." , okButton: "Ok", controller: self) {
            }
        }else if emailTF.text!.isValidEmail == false {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter vaild email." , okButton: "Ok", controller: self) {
            }
        }
        else if usernameTF.text!.trimWhiteSpace.isEmpty{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter username." , okButton: "Ok", controller: self) {
            }
        }
        else if birthdayDateTF.text!.trimWhiteSpace.isEmpty{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select your birthday." , okButton: "Ok", controller: self) {
            }
        }
        else if !iconClick {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please agree terms & conditions" , okButton: "Ok", controller: self) {
            }
        }
        else if googleUser == nil && appleLoginResponse == nil {
            if (passwordTF.text?.trimWhiteSpace.isEmpty)! {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter password." , okButton: "Ok", controller: self) {
                }
            }else if (passwordTF!.text!.count) < 6 || (passwordTF!.text!.count) > 15 {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Password should be minimum 6 digits." , okButton: "Ok", controller: self) {
                }
            }
            else if (confirmPasswordTF.text?.trimWhiteSpace.isEmpty)!{
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter confirm password." , okButton: "Ok", controller: self) {
                }
            }else if (confirmPasswordTF!.text!.count) < 6 || (passwordTF!.text!.count) > 15 {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Confirm password should be minimum 6 digits." , okButton: "Ok", controller: self) {
                }
            } else if passwordTF.text != confirmPasswordTF.text {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Confirm password mismatch." , okButton: "Ok", controller: self) {
                }
            } else {
                hitSignUpApi()
            }
        }
        else {
            //            self.pop()
            if googleUser != nil {
                hitGoogleLoginApi()
            } else if appleLoginResponse != nil {
                hitAppleLoginApi()
            }
//            else {
//                hitSignUpApi()
//            }
        }
    }
    
    

    //    MARK: PickerView Delegate & DataSource
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return organizationArr?.count ?? 0
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return organizationArr?[row].orgTitle
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.organizationTF.text = self.organizationArr?[row].orgTitle
            self.orgID = self.organizationArr?[row].orgID
        }

    
}
