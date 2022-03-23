//
//  EditProfileVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 29/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire


class EditProfileVC: BaseVC,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ImagePickerDelegate, UITextViewDelegate {
    
    func didSelect(image: UIImage?) {
        userImgView.image = image
        
    }
    
    let datePicker = UIDatePicker()
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var imagePicker : ImagePicker?
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                userImgView.image = selectedImage
            }
        }
    }
    
    
//    var organizationArr : [String] = ["Listener","Peer Support","Addiction","Intuitive","Motivation & Inspiration","Counsellor/Therapist"]
    var organizationArr : [SelectOrganizationData]?
    var profileData : GetProfileDataModel?
    var orgID : String?
    var imgArray = [Data]()
    var imgUrl = String()
    
    
    
    //    MARK: OUTLETS
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var editProfileImgBtn: UIButton!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var chooseUsernameView: UIView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var organizationView: UIView!
    @IBOutlet weak var organizationTF: UITextField!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var organizationPickerView: UIPickerView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        organizationData()
        uiConfigure()
        createDatePicker()
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.pop()
        
    }
    @IBAction func editProfileImgBtn(_ sender: UIButton) {
//        imagePicker?.present(from: sender)
        self.present(from: sender)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        if validate() == false {
            return
        }
        else {
//            self.pop()
            editProfileApi()
            print("Its editProfile")
        }
    }
    
    //    MARK: DATE PICKER
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        birthdayTF.inputAccessoryView = toolbar
        birthdayTF.inputView = datePicker
        let calendar = Calendar.current
        let backDate = calendar.date(byAdding: .year, value: -15, to: Date())
        datePicker.locale = NSLocale(localeIdentifier: "en_US") as Locale // 24 hour time
        datePicker.timeZone = TimeZone(identifier: "UTC")
        datePicker.maximumDate = backDate
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func donePressed() {
        if birthdayTF.isFirstResponder {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .none
            formatter.dateFormat = "MM/dd/yyyy"
            birthdayTF.text = formatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    
    
    // MARK: FUNCTIONS
    func uiConfigure() {
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        usernameTF.delegate = self
        organizationTF.delegate = self
        birthdayTF.delegate = self
        organizationPickerView.delegate = self
        organizationPickerView.dataSource = self
        organizationPickerView.isHidden = true
        firstNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        organizationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        chooseUsernameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        birthdayView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        userImgView.layer.applySketchShadow(y:0)
        showUserDetails()
        //MARK: IMAGE ROUND
        userImgView.layer.cornerRadius = userImgView.frame.height/2
        userImgView.clipsToBounds = true
        userImgView.layer.borderWidth = 0.5
        userImgView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
    }
    
    func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        if let profile = self.profileData?.profileDetails {
//            if profile.profileImage != ""  {
//                alertController.addAction(UIAlertAction(title: "Delete Photo", style: UIAlertAction.Style.default, handler: {_ in
//                    alertController.view.tintColor = .red
//                    print("handler")
//                    self.userImgView.image = nil
//                    self.deleteProfileImageApi()
//                }))
//            }
//        }
        let placeHolder = UIImage(named: "profilePlaceHolder")
        if imgUrl != "" {
            if userImgView.image?.pngData() != placeHolder?.pngData() {
                alertController.addAction(UIAlertAction(title: "Delete Photo", style: UIAlertAction.Style.default, handler: {_ in
                    alertController.view.tintColor = .red
                    print("handler")
    //                self.userImgView.image = nil
                    self.deleteProfileImageApi()
                }))
            }
        }
        
        if let action = imagePicker?.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = imagePicker?.action(for: .photoLibrary, title: "Choose Photo") {
            alertController.addAction(action)
        }
        
//        if let action = imagePicker?.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
//        if let action = imagePicker?.action(for: .photoLibrary, title: "Photo library") {
//            alertController.addAction(action)
//        }
        
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
//        self.presentationController?.present(alertController, animated: true)
        self.present(alertController, animated: true)
    }
    
    func organizationData() {
        if #available(iOS 13.0, *) {
            self.organizationArr = appDel.organizationArr
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func showUserDetails() {
        if let profileDetails = profileData?.profileDetails {
            firstNameTF.text = profileDetails.firstName
            lastNameTF.text = profileDetails.lastName
            emailTF.text = profileDetails.email
            usernameTF.text = profileDetails.userName
            birthdayTF.text = profileDetails.dob
            imgUrl = profileDetails.profileImage ?? ""
            let placeHolder = UIImage(named: "profilePlaceHolder")
            imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            userImgView.sd_setImage(with: URL(string: imgUrl), placeholderImage: placeHolder)
            if let orgDetails = profileDetails.organizationDetails {
                organizationTF.text = orgDetails.orgTitle
            }
        }
    }
    
    func editProfileApi() {
        self.imgArray.removeAll()
        if self.userImgView.image != UIImage(named: "profilePlaceHolder"){
            let compressedData = (userImgView.image?.jpegData(compressionQuality: 0.3))!
            if compressedData.isEmpty == false{
                imgArray.append(compressedData)
            }
        }
        
        let url = getFinalUrl(lastComponent: .editProfile)
        self.requestWith(endUrl: url, parameters: generatingParams())
    }
    
    func deleteProfileImageApi() {
        var deleteProfileImageResponse: SMModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .deleteProfileImage)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingDeleteImageParams(), headers: nil) { response in
            
            deleteProfileImageResponse = self.getDeleteProfileImageApiResponse(response: response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = deleteProfileImageResponse?.message
            if let status = deleteProfileImageResponse?.status {
                if status == 200 {
                    //                    self.AccounttableView.reloadData()
                    self.imgUrl = ""
                    self.userImgView.image = UIImage(named: "profilePlaceHolder")
                }
                else if status == 403 {
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        Globals.loginScreen()
                    }
                }
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    func generatingDeleteImageParams() -> [String:Any] {
        var params : [String:Any] = [:]
        let authToken  = getSAppDefault(key: DefaultKeys.authToken) as? String ?? ""
        params["authToken"] = authToken
        return params
    }
    
    func getDeleteProfileImageApiResponse(response: NSDictionary) -> SMModel? {
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
    
    
    func getApiResponse(response: NSDictionary) -> EditProfileDataModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let editProfileData = try JSONDecoder().decode(EditProfileDataModel.self, from: jsonData)
                return editProfileData
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
        params["userName"] = usernameTF.text
        params["firstName"] = firstNameTF.text
        params["lastName"] = lastNameTF.text
        params["orgID"] = orgID
        params["dob"] = birthdayTF.text
        print("params =>", params)
        return params
    }
    
    
    
    func requestWith(endUrl: String, parameters: [String : Any]) {
        
        let url = endUrl /* your API url */
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
            }
            
            
            for i in 0..<self.imgArray.count {
                let imageData1 = self.imgArray[i]
                debugPrint("mime type is\(imageData1.mimeType)")
                let ranStr = String().random(length: 7)// String.random(length: 7)
                if imageData1.mimeType == "application/pdf" ||
                    imageData1.mimeType == "application/vnd" ||
                    imageData1.mimeType == "text/plain"{
                    multipartFormData.append(imageData1, withName: "profileImage[\(i + 1)]" , fileName: ranStr + String(i + 1) + ".pdf", mimeType: imageData1.mimeType)
                }else{
                    multipartFormData.append(imageData1, withName: "profileImage" , fileName: ranStr + String(i + 1) + ".jpg", mimeType: imageData1.mimeType)
                }
            }
            
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: nil, interceptor: nil, fileManager: .default)
        
            .uploadProgress(closure: { (progress) in
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON { [self] (response) in
                DispatchQueue.main.async {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                }
                
                let respDict =  response.value as? [String : AnyObject] ?? [:]
                let response = self.getApiResponse(response: respDict)
                if let message = response?.message {
                    if let status = response?.status {
                        print(status)
                        showAlertMessage(title: AppAlertTitle.appName.rawValue, message: message, okButton: "OK", controller: self) {
                            self.pop()
                        }
                    }
                }
                
            }
    }
    
    func getApiResponse(response: [String: AnyObject]) -> EditProfileDataModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let profileData = try JSONDecoder().decode(EditProfileDataModel.self, from: jsonData)
                print("JSON", profileData)
                return profileData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return organizationArr?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return organizationArr?[row].orgTitle
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.organizationTF.text = self.organizationArr?[row].orgTitle
        self.orgID = self.organizationArr?[row].orgID
        self.organizationPickerView.isHidden = true
    }
    
    //    MARK: TEXTFIELD DELEGATE & DATASOURCE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = textField == firstNameTF ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameView.layer.borderColor = textField == lastNameTF ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.layer.borderColor = textField == emailTF ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        chooseUsernameView.layer.borderColor = textField == usernameTF ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        organizationView.layer.borderColor = textField == organizationTF ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        birthdayView.layer.borderColor = textField == birthdayTF ?  #colorLiteral(red: 0.08727987856, green: 0.366667062, blue: 0.6510989666, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if textField == self.organizationTF {
            self.organizationPickerView.isHidden = false
            organizationTF.endEditing(true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        chooseUsernameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        organizationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        birthdayView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    //   MARK: Validations
    func validate() -> Bool {
        if ValidationManager.shared.isEmpty(text: firstNameTF.text) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter first name." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: lastNameTF.text) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter last name." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: emailTF.text) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter email." , okButton: "Ok", controller: self) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: usernameTF.text) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter username." , okButton: "Ok", controller: self) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: organizationTF.text) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select organization." , okButton: "Ok", controller: self) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: birthdayTF.text) == true {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select birthdate." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        return true
    }
    
}
