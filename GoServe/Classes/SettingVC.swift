//
//  SettingVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 29/12/21.
//

import UIKit
import Alamofire

class SettingVC: BaseVC {
    
    var listArr: [String] = ["Edit Profile","Report a Problem","Change Password","About GoServe Now","Terms of Use","Privacy Policy","Logout"]
    var imgArr: [String] = ["editProfile","rt23","cp","ab","terms","pp","lg-1"]
    var profileData : GetProfileDataModel?

    
    //    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var settingTableViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(UINib(nibName: "SettingListCell", bundle: nil), forCellReuseIdentifier: "SettingListCell")
    }
    
    func getApiResponse(response: NSDictionary) -> SMModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let logOutData = try JSONDecoder().decode(SMModel.self, from: jsonData)
                print("JSON", logOutData)
                return logOutData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
    open func logOutApi() {
        var logOutResponse : SMModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
//        let authToken  = getSAppDefault(key: DefaultKeys.authToken) as? String ?? ""
//        let headers: HTTPHeaders = ["authToken": authToken] // [.authorization(bearerToken: authToken)]
        let url = getFinalUrl(lastComponent: .logOut)
        AFWrapperClass.requestPostWithMultiFormData(url, params:generatingParams(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            logOutResponse = self.getApiResponse(response: response)
            let message = logOutResponse?.message // response["message"] as? String ?? ""
            if let status = logOutResponse?.status {  // response["status"] as? Int {
                if status == 200 {
                    removeAppDefaults(key:DefaultKeys.authToken)
                    if #available(iOS 13.0, *) {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        appDel.logOut()
                    } else {
                        // Fallback on earlier versions
                    }
                    //}
                }
                else if status == 401 {
                    removeAppDefaults(key:DefaultKeys.authToken)
                    if #available(iOS 13.0, *) {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        appDel.logOut()
                    } else {
                        // Fallback on earlier versions
                    }
                    
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
        return params
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
    }
    
}
extension SettingVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let controller = NavigationManager.shared.editProfile
            controller.profileData = self.profileData
            self.push(controller: controller, animated: true)
        }
        if indexPath.row == 1{
            let controller = NavigationManager.shared.support
            controller.profileData = self.profileData
            self.push(controller: controller, animated: true)
        }
        else if indexPath.row == 2 {
            let controller = NavigationManager.shared.changePassword
            self.push(controller: controller, animated: true)
        }
        else if indexPath.row == 3 {
            let controller = NavigationManager.shared.webViewVC
            controller.titleText = "About Us"
            self.push(controller: controller, animated: true)
        }
        else if indexPath.row == 4 {
            let controller = NavigationManager.shared.webViewVC
            controller.titleText = "Terms & Conditions"
            self.push(controller: controller, animated: true)
        }
        else if indexPath.row == 5 {
            let controller = NavigationManager.shared.webViewVC
            controller.titleText = "Privacy Policy"
            self.push(controller: controller, animated: true)
        }
        else if indexPath.row == 6 {
            self.popActionAlert(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to log out from the app?", actionTitle: ["Ok","Cancel"], actionStyle: [.default, .cancel], action: [{ [self] ok in
                logOutApi()
//                self.navigationController?.popToRootViewController(animated: true)
            },{
                cancel in
                self.dismiss(animated: false, completion: nil)
            }])
            print("User logout successfully")
        }
        
        else {
            print("Its working")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell", for: indexPath) as! SettingListCell
        cell.lblCell.text = listArr[indexPath.row]
        let image = UIImage(named: imgArr[indexPath.row])
        cell.imgcell.image = image
        return cell
    }
    
}
