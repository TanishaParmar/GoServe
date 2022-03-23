//
//  AccountVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 28/12/21.
//

import UIKit

class AccountVC: BaseVC {
    
    var titleArr : [String] = ["Being the savage","Being Human","Being Humble"]
    
//        let rangeSlider = RangeSlider(frame: .zero)

    
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userOrganizationLbl: UILabel!
    @IBOutlet weak var trackerCountLbl: UILabel!
    @IBOutlet weak var trackerView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var AccounttableView: UITableView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var recentPostBtn: UIButton!
    @IBOutlet weak var recentLbl: UILabel!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var editProfilrbtn: UIButton!
    @IBOutlet weak var organizationSchoolBtn: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var recentPostImage: UIImageView!
    
    var profileData : GetProfileDataModel?
    var upcomingPastOpportunitiesData : [OpportunitiesData]?


    var opportunityType : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiUpdate()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileApi()
    }
    
    func uiUpdate() {
        self.progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)
        AccounttableView.delegate = self
        AccounttableView.dataSource = self
        AccounttableView.register(UINib(nibName: "AccountListCell", bundle: nil), forCellReuseIdentifier: "AccountListCell")
        userProfileImg.layer.cornerRadius = userProfileImg.frame.height/2
        userProfileImg.clipsToBounds = true
        userProfileImg.layer.cornerRadius = userProfileImg.frame.height/2
        userProfileImg.clipsToBounds = true
        userProfileImg.layer.borderWidth = 1
        userProfileImg.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        postLbl.layer.backgroundColor = #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)
        recentLbl.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func getProfileApi() {
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .getProfile)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            print(response)
            self.profileData = self.getApiResponse(response: response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = self.profileData?.message
            if let status = self.profileData?.status {
                if status == 200 {
                    self.setProfileDetails()
                    self.upcomingPastApi()
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
    
    func getApiResponse(response: NSDictionary) -> GetProfileDataModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let profileData = try JSONDecoder().decode(GetProfileDataModel.self, from: jsonData)
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
        print("params =>", params)
        return params
    }
    
    func upcomingPastApi() {
        self.alertLabel.isHidden = true
        var upcomingPastOpportunitiesResponse: OpportunitiesAllResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .getAllComingPastOpportunitiesByType)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingupcomingPastParams(), headers: nil) { response in

            upcomingPastOpportunitiesResponse = self.getUpcomingPastApiResponse(response: response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = upcomingPastOpportunitiesResponse?.message
            if let status = upcomingPastOpportunitiesResponse?.status {
                if status == 200 {
                    self.upcomingPastOpportunitiesData = upcomingPastOpportunitiesResponse?.opportunitiesData
                    //                    self.AccounttableView.reloadData()
                }
                else if status == 403 {
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        Globals.loginScreen()
                    }
                }
                else {
                    self.upcomingPastOpportunitiesData = nil
                    self.alertLabel.isHidden = false
                    self.alertLabel.text = "No Opportunities Found"
//                    alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
                }
                self.AccounttableView.reloadData()
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    func generatingupcomingPastParams() -> [String:Any] {
        var params : [String:Any] = [:]
        let authToken  = getSAppDefault(key: DefaultKeys.authToken) as? String ?? ""
        params["authToken"] = authToken
        params["type"] = self.opportunityType
        params["pageNo"] = 1
        params["perPage"] = 5000
        print("params =>", params)
        return params
    }
    
    func getUpcomingPastApiResponse(response: NSDictionary) -> OpportunitiesAllResponseModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let profileData = try JSONDecoder().decode(OpportunitiesAllResponseModel.self, from: jsonData)
                return profileData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
    
    func setProfileDetails() {
        if let profileDetails = profileData?.profileDetails {
            userNameLbl.text = (profileDetails.firstName ?? "") + " " + (profileDetails.lastName ?? "")
            userEmailLbl.text = profileDetails.email
            trackerCountLbl.text = (profileDetails.hourTracker ?? "") //+ " " + "hour"
            var imgUrl = profileDetails.profileImage ?? ""
            let placeHolder = UIImage(named: "profilePlaceHolder")
            imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            userProfileImg.sd_setImage(with: URL(string: imgUrl), placeholderImage: placeHolder)
            if let orgDetails = profileDetails.organizationDetails {
                organizationSchoolBtn.isUserInteractionEnabled = true
                userOrganizationLbl.text = orgDetails.orgTitle
            }
            else {
                organizationSchoolBtn.isUserInteractionEnabled = false
            }
        }
    }
    
    
    @IBAction func settingBtn(_ sender: UIButton) {
        let controller = NavigationManager.shared.setting
        controller.profileData = self.profileData
        self.push(controller: controller, animated: true)
    }
    
    @IBAction func editProfilrBtn(_ sender: UIButton) {
        let controller = NavigationManager.shared.editProfile
        controller.profileData = self.profileData
        self.push(controller: controller, animated: true)
    }
    
    @IBAction func organizationBtn(_ sender: UIButton) {
        let controller = NavigationManager.shared.organizationDetail
        if let profileData = profileData?.profileDetails {
            if let orgData = profileData.organizationDetails {
                controller.orgDetails = orgData
            }
        }
        self.push(controller: controller, animated: true)
    }
    
    @IBAction func postBtn(_ sender: UIButton) {
        postLbl.layer.backgroundColor = #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)
        recentLbl.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        postImage.image = UIImage(named:"icon1")
        recentPostImage.image = UIImage(named:"past")
        opportunityType = 1
        upcomingPastApi()
    }
    
    
    @IBAction func recentPostBtn(_ sender: UIButton) {
        recentLbl.layer.backgroundColor = #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)
        postLbl.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        postImage.image = UIImage(named:"icon2")
        recentPostImage.image = UIImage(named:"past2")
        opportunityType = 2
        upcomingPastApi()
    }
    

}
extension AccountVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return titleArr.count
        print("result is =>", upcomingPastOpportunitiesData?.count ?? 0)
        return upcomingPastOpportunitiesData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NavigationManager.shared.detail
        controller.isFromUpcomingPast = true
        controller.opportunitiesData = self.upcomingPastOpportunitiesData?[indexPath.row]
        self.push(controller: controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 226
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountListCell", for: indexPath) as! AccountListCell
//        cell.titlecell.text = titleArr[indexPath.row]
        var imgUrl = self.upcomingPastOpportunitiesData?[indexPath.row].opImage ?? ""
        let placeHolder = UIImage(named: "homeScreenPlaceHolder")
        imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.imgCell.sd_setImage(with: URL(string: imgUrl), placeholderImage: placeHolder)
        cell.titlecell.text = self.upcomingPastOpportunitiesData?[indexPath.row].title
        cell.descriptionCell.text = self.upcomingPastOpportunitiesData?[indexPath.row].description
        return cell
    }
    
    
}
