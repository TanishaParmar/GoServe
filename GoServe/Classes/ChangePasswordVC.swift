//
//  ChangePasswordVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 29/12/21.
//

import UIKit
import Alamofire

class ChangePasswordVC: BaseVC,UITextFieldDelegate {
//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var currentPwdView: UIView!
    @IBOutlet weak var currentPwdTf: UITextField!
    @IBOutlet weak var newPwdView: UIView!
    @IBOutlet weak var newPwdTf: UITextField!
    @IBOutlet weak var confirmNewPwdView: UIView!
    @IBOutlet weak var confirmNewPwdTF: UITextField!
    @IBOutlet weak var updatePwdBtn: UIButton!
    @IBOutlet weak var oldPasswordEyeImageView: UIImageView!
    @IBOutlet weak var confirmPasswordEyeImageView: UIImageView!
    @IBOutlet weak var newPasswordEyeImageView: UIImageView!
    @IBOutlet weak var oldPasswordBtn: UIButton!
    @IBOutlet weak var newPasswordBtn: UIButton!
    @IBOutlet weak var confirmPasswordBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        uiUpdate()
    }
    @IBAction func updatePwdBtn(_ sender: UIButton) {
        changePasswordApi()
        if validate() == false {
            return
        }
        else{
            changePasswordApi()
//            self.pop()
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()

    }
    
    @IBAction func oldPasswordBtnAction(_ sender: Any) {
        oldPasswordBtn.isSelected = !oldPasswordBtn.isSelected
        if oldPasswordBtn.isSelected {
            currentPwdTf.isSecureTextEntry = false
            oldPasswordEyeImageView.image = UIImage(named:"ey")
            oldPasswordBtn.contentMode = .scaleAspectFit
        } else {
            currentPwdTf.isSecureTextEntry = true
            oldPasswordEyeImageView.image = UIImage(named:"eye")
            oldPasswordBtn.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func newPasswordBtnAction(_ sender: Any) {
        newPasswordBtn.isSelected = !newPasswordBtn.isSelected
        if newPasswordBtn.isSelected {
            newPwdTf.isSecureTextEntry = false
            newPasswordEyeImageView.image = UIImage(named:"ey")
            newPasswordBtn.contentMode = .scaleAspectFit
        } else {
            newPwdTf.isSecureTextEntry = true
            newPasswordEyeImageView.image = UIImage(named:"eye")
            newPasswordBtn.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func confirmPasswordBtnAction(_ sender: Any) {
        confirmPasswordBtn.isSelected = !confirmPasswordBtn.isSelected
        if confirmPasswordBtn.isSelected {
            confirmNewPwdTF.isSecureTextEntry = false
            confirmPasswordEyeImageView.image = UIImage(named:"ey")
            confirmPasswordBtn.contentMode = .scaleAspectFit
        } else {
            confirmNewPwdTF.isSecureTextEntry = true
            confirmPasswordEyeImageView.image = UIImage(named:"eye")
            confirmPasswordBtn.contentMode = .scaleAspectFit
        }
    }
    
    
    //    MARK: Validation
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: currentPwdTf.text) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter old password." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: newPwdTf.text ) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter new password." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: confirmNewPwdTF.text ) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter confirm new password." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isValidConfirm(password: newPwdTf.text!, confirmPassword: confirmNewPwdTF.text!) == false{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "New password or Confirm password not match ", okButton: "OK", controller: self){
                
            }
            print("Password match.")
            return false
        }
        
        return true
    }
    
    
    func getApiResponse(response: NSDictionary) -> SMModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: [])
        {
            do {
                let loginData = try JSONDecoder().decode(SMModel.self, from: jsonData)
                print("JSON", loginData)
                return loginData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
    func changePasswordApi() {
        var forgotPasswordResponse : SMModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        
//        let authToken  = getSAppDefault(key: DefaultKeys.authToken) as? String ?? ""
//        let headers: HTTPHeaders = [.authorization(bearerToken: authToken)]

        let url = getFinalUrl(lastComponent: .changePassword)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            forgotPasswordResponse = self.getApiResponse(response: response)
            let message = forgotPasswordResponse?.message // response["message"] as? String ?? ""
            if let status = forgotPasswordResponse?.status {   // response["status"] as? Int {
                if status == 200{
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else if status == 401{
                    removeAppDefaults(key:DefaultKeys.authToken)
//                    appDel.logOut()
                }
                else{
                    alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
                }
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    func generatingParams() -> [String:Any] {
        var params : [String:Any] = [:]
        let authToken  = getSAppDefault(key: DefaultKeys.authToken) as? String ?? ""
        params["authToken"] = authToken
        params["oldPassword"] = currentPwdTf.text
        params["newPassword"] = newPwdTf.text
        params["confirmPassword"] = confirmNewPwdTF.text
        return params
    }
    
    
    //MARK:  textfeild delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentPwdView.layer.borderColor = textField == currentPwdTf ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        newPwdView.layer.borderColor = textField == newPwdTf ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        confirmNewPwdView.layer.borderColor = textField == confirmNewPwdTF ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentPwdView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        newPwdView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        confirmNewPwdView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func uiUpdate() {
        currentPwdView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        newPwdView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        confirmNewPwdView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        currentPwdTf.delegate = self
        newPwdTf.delegate = self
        confirmNewPwdTF.delegate = self
    }
    
    
}

