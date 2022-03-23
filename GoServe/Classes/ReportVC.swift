//
//  ReportVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 03/01/22.
//

import UIKit
import FittedSheets

class ReportVC: BaseVC {
    
    var titleArr : [String] = ["Its' spam","False Information","I just don't like it","Lorem Ipsum","I just don't like it"]
    
//    MARK: OUTLETS
    @IBOutlet weak var decriptionLbl: UILabel!
    @IBOutlet weak var reportTableView: UITableView!
    
    var reportReasonData : [GetAllReportReasonData]?
    var report: OpportunitiesData?
    var reportType: Int?
    var reasonID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.register(UINib(nibName: "ReportListCell", bundle: nil), forCellReuseIdentifier: "ReportListCell")
    }
    
    static func instantiate() -> ReportVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
    }
    
    //MARK: - Add Report Api's
    func hitAddReportApi() {
        var reportResponse : SMModel?

        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .addReport)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in

            reportResponse = self.getApiResponse(response: response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = reportResponse?.message
            if let status = reportResponse?.status {
                if status == 200 {
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    func getApiResponse(response: NSDictionary) -> SMModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let reportData = try JSONDecoder().decode(SMModel.self, from: jsonData)
                return reportData
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
        params["reasonId"] = reasonID
        params["reportedId"] = report?.opID
        params["reportType"] = reportType
        print("params =>", params)
        return params
    }

    

}
extension ReportVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return titleArr.count
        reportReasonData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportListCell", for: indexPath) as! ReportListCell
//        cell.lblCell.text = titleArr[indexPath.row]
        cell.lblCell.text = self.reportReasonData?[indexPath.row].reportReasons
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select called")
        let index = self.reportReasonData?[indexPath.row].reasonId
        self.reasonID = Int(index ?? "0")
        hitAddReportApi()
    }
    
    
}
