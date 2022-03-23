//
//  NotificationVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 27/12/21.
//

import UIKit

class NotificationVC: BaseVC {
        
    //    MARK: OUTLETS
    @IBOutlet weak var notifyTableView: UITableView!
    
    var notifyData: [NotificationData]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifyTableView.delegate = self
        notifyTableView.dataSource = self
        notifyTableView.register(UINib(nibName: "NotificationListCell", bundle: nil), forCellReuseIdentifier: "NotificationListCell")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitNotificationsApi()
    }
    
    //MARK: - Notifications Api's
    func hitNotificationsApi() {
        var notificationResponse : NotificationResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .notificationActivity)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            print(response)
            notificationResponse = self.getApiResponse(response: response)
            print(notificationResponse)
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = notificationResponse?.message
            if let status = notificationResponse?.status {
                if status == 200 {
                    self.notifyData = notificationResponse?.notificationData
                    self.notifyTableView.reloadData()
                }
                else if status == 403 {
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        Globals.loginScreen()
                    }
                }
                else {
                    alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
                }
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    func getApiResponse(response: NSDictionary) -> NotificationResponseModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let opportunitiesData = try JSONDecoder().decode(NotificationResponseModel.self, from: jsonData)
                return opportunitiesData
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
        params["pageNo"] = 1
        print("params =>", params)
        return params
    }
    
    
}
extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifyData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationListCell", for: indexPath) as! NotificationListCell
        var imgUrl: String?
        let notificationIndex = notifyData?[indexPath.row]
        if notificationIndex?.notification_type == "2" {
            imgUrl = notificationIndex?.organizationDetails?.orgImage ?? ""
        }
        else if notificationIndex?.notification_type == "6" || notificationIndex?.notification_type == "12" || notificationIndex?.notification_type == "13" || notificationIndex?.notification_type == "14" { // opp
            imgUrl = notificationIndex?.opportunityDetails?.opImage ?? ""
        } else {
            imgUrl = notifyData?[indexPath.item].profileImage ?? ""
        }
        
        let placeHolder = UIImage(named: "notifyIcon")
        imgUrl = imgUrl?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.imgCell.sd_setImage(with: URL(string: imgUrl ?? ""), placeholderImage: placeHolder)
        cell.notificationTitleLbl.text = notifyData?[indexPath.item].title
        cell.notificationLbl.text = notifyData?[indexPath.item].description
        let timeStamp = Double(notifyData?[indexPath.item].created ?? "")
        let date = convertTimeStampToDate(dateVal: timeStamp!)
        cell.dateLbl.text = date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationIndex = notifyData?[indexPath.row]
        if notificationIndex?.notification_type == "2" { // org
            let orgData = notificationIndex?.organizationDetails
            let controller = NavigationManager.shared.organizationDetail
            controller.orgDetails = orgData
            self.push(controller: controller, animated: true)
        } else if notificationIndex?.notification_type == "6" || notificationIndex?.notification_type == "12" || notificationIndex?.notification_type == "13" || notificationIndex?.notification_type == "14" { // opp
            let oppData = notificationIndex?.opportunityDetails
            let controller = NavigationManager.shared.detail
            controller.opportunitiesData = oppData
            controller.isFromUpcomingPast = true
            self.push(controller: controller, animated: true)

        }
    }
    
}
    
