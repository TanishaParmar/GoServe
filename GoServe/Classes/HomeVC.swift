//
//  HomeVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 24/12/21.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD


class HomeVC: BaseVC {
    var imgArr : [String] = ["coctail","imag","istockphot","istockphoto"]
    
    //    MARK: OUTLETS
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var oportunitiesTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var seachOpportunities: UISearchBar!
    @IBOutlet weak var alertLabel: UILabel!
    
    
    //MARK: - variable declaration
    var opportunitiesResponseData: [OpportunitiesData]?
    var notificationData : [String : Any]?
    var isPushNotify = false
    var isFromFilter = false
    
    
    //MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        if isPushNotify {
            pushRedirect()
        }
        oportunitiesTableView.delegate = self
        oportunitiesTableView.dataSource = self
        oportunitiesTableView.register(UINib(nibName: "OpportunitiesListCell", bundle: nil), forCellReuseIdentifier: "OpportunitiesListCell")
        searchView.isHidden = true
        seachOpportunities.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchView.isHidden = true
        if !isFromFilter {
            hitAllTabApi()
        }
        isFromFilter = false
    }
    
    func addObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("filterResponse"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(oppResponse(notification:)), name: NSNotification.Name("filterResponse"), object: nil)
    }
    
    @objc func oppResponse(notification: NSNotification) {
        print(notification)
        if let dict = notification.userInfo?["oppDetails"] as? [OpportunitiesData] {
            print(dict)
            isFromFilter = true
            opportunitiesResponseData = dict
            oportunitiesTableView.reloadData()
        }
    }
    
    func pushRedirect() {
        let notificationIndex = notificationData?["notification_type"] as? String
        if notificationIndex == "2" { // org
            let orgData = notificationData?["organizationDetails"] as? NSDictionary
            let orgDetails = getOrganizationApiResponse(response: orgData!)
            let controller = NavigationManager.shared.organizationDetail
            controller.orgDetails = orgDetails
            self.push(controller: controller, animated: true)
        } else if notificationIndex == "6" || notificationIndex == "12" || notificationIndex == "13" || notificationIndex == "14" { // opp
            let oppData = notificationData?["opportunityDetails"] as? NSDictionary
            let oppDetails = getOpportunityApiResponse(response: oppData!)
            let controller = NavigationManager.shared.detail
            controller.opportunitiesData = oppDetails
            controller.isFromUpcomingPast = true
            self.push(controller: controller, animated: true)
        }
    }
    
    
    //MARK: - Opportunities Api's
    func hitAllTabApi() {
        var opportunitiesResponse : OpportunitiesAllResponseModel?
//        DispatchQueue.main.async {
//            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        }
        self.alertLabel.isHidden = true
        SVProgressHUD.show(withStatus: "Loading...")
        let url = getFinalUrl(lastComponent: .getAllOpportunitiesByTypev2)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            print(response)
            opportunitiesResponse = self.getApiResponse(response: response)
            self.opportunitiesResponseData = opportunitiesResponse?.opportunitiesData
            self.oportunitiesTableView.reloadData()
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = opportunitiesResponse?.message // response["message"] as? String ?? ""
            if let status = opportunitiesResponse?.status {   // response["status"] as? Int {
                if status == 200 {
                    //                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                    
                    //                    }
                }
                else if status == 403 {
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        Globals.loginScreen()
                    }
                }
                else {
                    self.alertLabel.isHidden = false
                    self.alertLabel.text = "No Opportunities Found"
                    //alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
                }
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    func getApiResponse(response: NSDictionary) -> OpportunitiesAllResponseModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let opportunitiesData = try JSONDecoder().decode(OpportunitiesAllResponseModel.self, from: jsonData)
                return opportunitiesData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
    func getOrganizationApiResponse(response: NSDictionary) -> OrganizationDetails? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let organizationData = try JSONDecoder().decode(OrganizationDetails.self, from: jsonData)
                return organizationData
            } catch {
                print("ERROR:", error)
                return nil
            }
        }
        return nil
    }
    
    func getOpportunityApiResponse(response: NSDictionary) -> OpportunitiesData? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let OpportunitiesData = try JSONDecoder().decode(OpportunitiesData.self, from: jsonData)
                return OpportunitiesData
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
        params["search"] = seachOpportunities.text?.lowercased()
        params["perPage"] = 5000
        params["pageNo"] = 1
        print("params =>", params)
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("First Segment Selected")
            params["type"] = 1
        case 1:
            print("Second Segment Selected")
            params["type"] = 2
        default:
            break
        }
        return params
    }
    
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        hitAllTabApi()
    }
    
    
    
    @IBAction func searchBtn(_ sender: UIButton) {
        searchView.isHidden = false
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        searchView.isHidden = true
        seachOpportunities.text = ""
        hitAllTabApi()
        self.view.endEditing(true)
    }
    
    @IBAction func filterbtn(_ sender: UIButton) {
//        saveEvent()
        let controller = NavigationManager.shared.filter
        controller.selectedType = segmentControl.selectedSegmentIndex
        self.push(controller: controller, animated: true)
    }
    
    
}

extension HomeVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        opportunitiesResponseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpportunitiesListCell", for: indexPath) as! OpportunitiesListCell
        if self.opportunitiesResponseData!.count > indexPath.row {
            let url = URL(string: self.opportunitiesResponseData?[indexPath.row].opImage ?? "")
            let placeHolder = UIImage(named: "homeScreenPlaceHolder")
            cell.imgCell.sd_setImage(with: url, placeholderImage: placeHolder)
            cell.attactBtn.tag = indexPath.row
            cell.attactBtn.addTarget(self, action: #selector(showAttachView), for: .touchUpInside)
            cell.nameLbl.text = self.opportunitiesResponseData?[indexPath.row].title
            cell.descriptionLbl.text = self.opportunitiesResponseData?[indexPath.row].description
            cell.timeLbl.text = self.opportunitiesResponseData?[indexPath.row].opHour
            if let isAds = self.opportunitiesResponseData?[indexPath.row].isAds {
                if isAds == "1" {
                    cell.timeLbl.isHidden = true
                    cell.timeLabelHeight.constant = 0
                    cell.attactBtn.isHidden = true
                    cell.attachImageView.isHidden = true
                } else {
                    cell.timeLbl.isHidden = false
                    cell.attachImageView.isHidden = false
                    cell.attactBtn.isHidden = false
                    cell.timeLabelHeight.constant = 20
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let isAds = self.opportunitiesResponseData?[indexPath.row].isAds {
            if isAds == "1" {
                if let isLink = self.opportunitiesResponseData?[indexPath.row].link {
                    let link = URL(string: isLink)!
                    UIApplication.shared.openURL(link)
                }
            } else {
                let controller = NavigationManager.shared.detail
                
                controller.opportunitiesData = self.opportunitiesResponseData?[indexPath.row]
                self.push(controller: controller, animated: true)
            }
        }
    }
    
    @objc func showAttachView(sender : UIButton) {
        var parentCell = sender.superview
        while !(parentCell is UITableViewCell) {
            parentCell = parentCell?.superview
        }
        var indexPath : IndexPath? = nil
        if let cell = parentCell as? UITableViewCell {
            indexPath = oportunitiesTableView.indexPath(for: cell)
        }
        let report = self.opportunitiesResponseData?[indexPath?.row ?? 0]
        
        let controller = NavigationManager.shared.popUp
        controller.report = report
        controller.reportType = segmentControl.selectedSegmentIndex
        self.present(controller, animated: true, completion: nil)
        print("Its attach button")
    }
    
    @objc func detailView(sender : UIButton) {
        let controller = NavigationManager.shared.detail
        self.push(controller: controller, animated: true)
        print("its detail view")
    }

}


extension HomeVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search bar text is =>", searchText)
        hitAllTabApi()
    }
    
}
