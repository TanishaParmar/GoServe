//
//  ForgotPasswordVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 24/12/21.
//

import UIKit

class ForgotPasswordVC: BaseVC ,UITextFieldDelegate{
    
//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        validation()
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
    }
    
    func uiConfigure(){
        emailTF.delegate = self
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
    
    func forgotPasswordApi() {
        var forgotPasswordResponse : SMModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .forgetPassword)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            forgotPasswordResponse = self.getApiResponse(response: response)
            let message = forgotPasswordResponse?.message //response["message"] as? String ?? ""
            if let status = forgotPasswordResponse?.status { // response["status"] as? Int {
                if status == 200{
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
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
        params["email"] = emailTF.text
        return params
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.layer.borderColor = textField == emailTF ?  #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //   MARK: Validations
    func validation() {
        if emailTF.text?.trimWhiteSpace == ""{
            self.Alert(message: "Please enter email" )
        }else if emailTF.text!.isValidEmail == false{
            self.Alert(message: "Please enter a valid Email")
        }else{
//            self.pop()
            forgotPasswordApi()
        }
    }
}

extension UIViewController{
    
    func Alert(message:String){
        let clr = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let attributedString = NSAttributedString(string: AppAlertTitle.appName.rawValue, attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : clr
        ])
        let Alert = UIAlertController.init(title: AppAlertTitle.appName.rawValue, message: message, preferredStyle: .alert)
        Alert.setValue(attributedString, forKey: "attributedTitle")
        let ok = UIAlertAction.init(title: "ok", style: .default, handler: {
            Action in
        })
        Alert.addAction(ok)
        Alert.view.tintColor = clr
        self.present(Alert, animated: true, completion: nil)
    }
}
