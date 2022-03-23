//
//  ReportAProblemVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 03/01/22.
//

import UIKit
import IQKeyboardManagerSwift

class ReportAProblemVC: BaseVC,UITextFieldDelegate,UITextViewDelegate {

//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var mesgView: UIView!
    
    var profileData : GetProfileDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func sendQueryBtn(_ sender: UIButton) {
        if validate() == false {
            return
        }else{
            print("its report")
            contactUsApi()
        }
    }
    
    //    MARK: FUNCTIONS
    
    func uiConfigure() {
        nameTF.delegate = self
        emailTF.delegate = self
        messageTextView.delegate = self
        if let profileDetails = profileData?.profileDetails {
            nameTF.text = profileDetails.userName
            emailTF.text = profileDetails.email
        }
    }
    
    func contactUsApi() {
        var reportResponse : SMModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .contactUs)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in

            reportResponse = self.getApiResponse(response: response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = reportResponse?.message ?? ""
            if let status = reportResponse?.status {
                if status == 200 {
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: message, okButton: "OK", controller: self) {
                        self.pop()
                    }
                }
                else {
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    func getApiResponse(response: NSDictionary) -> SMModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let profileData = try JSONDecoder().decode(SMModel.self, from: jsonData)
                return profileData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
           
    func generatingParams() -> [String:Any] {
        var params : [String:Any] = [:]
        let authToken  = getSAppDefault(key: DefaultKeys.authToken) as? String ?? ""
        params["authToken"] = authToken
        params["name"] = nameTF.text
        params["email"] = emailTF.text
        params["message"] = messageTextView.text
        print("params =>", params)
        return params
    }

    
    
    //   MARK: Validations
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: nameTF.text) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter name." , okButton: "Ok", controller: self) {
            }
            return false
        }
        if emailTF.text!.isValidEmail == false{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter vaild email." , okButton: "Ok", controller: self) {
            }
        }
        
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameView.layer.borderColor = textField == nameTF ?  #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1)  :  #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        emailView.layer.borderColor = textField == emailTF ?  #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1)  :  #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        emailView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        mesgView.layer.borderColor = #colorLiteral(red: 0.07755983621, green: 0.3313153088, blue: 0.5845894217, alpha: 1)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        mesgView.layer.borderColor = #colorLiteral(red: 0.666592598, green: 0.6667093039, blue: 0.666585207, alpha: 1)
    }

}
