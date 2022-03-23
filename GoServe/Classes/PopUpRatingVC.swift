//
//  PopUpRatingVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 27/12/21.
//

import UIKit
import FittedSheets

class PopUpRatingVC: UIViewController {
    
    //    MARK: OUTLETS
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var dataView: UIView!
    
    var selected:Bool?
    var report: OpportunitiesData?
    var reportType: Int?
    var reportReasonData : [GetAllReportReasonData]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func bottomSheetView(){
        let controller = ReportVC.instantiate()
        var sizes = [SheetSize]()
        controller.reportReasonData = self.reportReasonData
        controller.report = report
        controller.reportType = reportType
        
        if selected == true {
            sizes.append(.fixed(UIScreen.main.bounds.size.height * 0.9))
            sizes.append(.marginFromTop(60))
            let sheetController = SheetViewController(controller: controller, sizes: sizes)
            self.present(sheetController, animated: true, completion: nil)
        } else {
            sizes.append(.fixed(UIScreen.main.bounds.size.height * 0.5))
            sizes.append(.marginFromTop(60))
            let sheetController = SheetViewController(controller: controller, sizes: sizes)
            self.present(sheetController, animated: true, completion: nil)
        }
    }
    
    
//    MARK: BUTTON ACTIONS
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareBtn(_ sender: UIButton) {
        let image = UIImage(named: "istockphot")
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
                
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func reportBtn(_ sender: UIButton) {
        selected = true
        hitReportApi()
    }
    
//        MARK: FUNCTIONS
    
    //MARK: - Report Opportunities Api's
    func hitReportApi() {
        var reportReasonResponse : GetAllReportReasonsModel?

        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .getAllReportReasons)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in

            reportReasonResponse = self.getApiResponse(response: response)
            self.reportReasonData = reportReasonResponse?.getAllReportReasonData
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = reportReasonResponse?.message 
            if let status = reportReasonResponse?.status {
                if status == 200 {
                        self.bottomSheetView()
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
    
    func getApiResponse(response: NSDictionary) -> GetAllReportReasonsModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) {
            do {
                let reportData = try JSONDecoder().decode(GetAllReportReasonsModel.self, from: jsonData)
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
        print("params =>", params)
        return params
    }
    
    
    var centerFrame : CGRect!
    
    func presentPopUp() {
        self.view.backgroundColor = .none
        dataView.frame = CGRect(x: centerFrame.origin.x, y: view.frame.size.height, width: centerFrame.width, height: centerFrame.height)
        dataView.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.dataView.frame = self.centerFrame
        }, completion: nil)
    }
    
    
    func dismissPopUp(_ dismissed:@escaping ()->()) {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.dataView.frame = CGRect(x: self.centerFrame.origin.x, y: self.view.frame.size.height, width: self.centerFrame.width, height: self.centerFrame.height)
            
        },completion:{ (completion) in
            self.dismiss(animated: false, completion: {
            })
        })
    }
    
    
        
    
}
