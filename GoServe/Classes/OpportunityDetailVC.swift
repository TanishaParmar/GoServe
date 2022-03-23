//
//  OpportunityDetailVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 27/12/21.
//

import UIKit
import EventKit

class OpportunityDetailVC: BaseVC {
    
// MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imgDetailVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var peopleCountLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var postTimeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var joinOpportunityBtn: UIButton!
    @IBOutlet weak var markEventButton: UIButton!
    
    var opportunitiesData : OpportunitiesData?
    var isFromUpcomingPast = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIElement()
        displayOpportunitiesData()
    }
    
    
    //MARK: - Methods
    func displayOpportunitiesData() {
        let url = URL(string: opportunitiesData?.opImage ?? "")
        let placeHolder = UIImage(named: "detailedScreenPlaceHolder")
        imgDetailVw.sd_setImage(with: url, placeholderImage: placeHolder)
        titleLbl.text = opportunitiesData?.title
        peopleCountLbl.text = opportunitiesData?.peopleRequired
        postTimeLbl.text = opportunitiesData?.opHour
        emailLbl.text = opportunitiesData?.email
        addressLbl.text = opportunitiesData?.opAddress
        descriptionLbl.text = opportunitiesData?.description
        setDateAndTime()
    }
    
    func setDateAndTime() {
//        let startTimeStamp = Double(self.opportunitiesData?.startTimeForAddEvent ?? "")!
//        let endTimeStamp = Double(self.opportunitiesData?.endTimeForAddEvent ?? "")!
//        let startTime = convertTimeStampToTime(dateVal: startTimeStamp)
//        let endTime = convertTimeStampToTime(dateVal: endTimeStamp)
//
//        let time = (startTime) + " - " + (endTime)
//        timeLbl.text = time
//        let date = (opportunitiesData?.startDateInDate ?? "") + " - " + (opportunitiesData?.endDateInDate ?? "")
//        let daysDiff = (date)  + " " + (opportunitiesData?.dayDiff ?? "")
//        dateLbl.text = daysDiff
        
        let startTime = (opportunitiesData?.startTime ?? "") + " (EST)" + " - "
        let endTime = (opportunitiesData?.endTime ?? "") + (" (EST)")
//        let time = (opportunitiesData?.startTime ?? "") + "UTC" + " - " + (opportunitiesData?.endTime ?? "") + ("UTC")
        let time = startTime + endTime
        timeLbl.text = time
        let date = (opportunitiesData?.startDateInDate ?? "") + " - " + (opportunitiesData?.endDateInDate ?? "")
        let daysDiff = (date)  + " " + (opportunitiesData?.dayDiff ?? "")
        dateLbl.text = daysDiff
    }
    
    func setUIElement() {
        markEventButton.isHidden = true
        markEventButton.isUserInteractionEnabled = false
        if isFromUpcomingPast {
            joinOpportunityBtn.isHidden = true
        }
        if opportunitiesData?.isStatus == "0" || opportunitiesData?.isStatus == "3" {
            joinOpportunityBtn.isUserInteractionEnabled = true
            joinOpportunityBtn.setTitle("Join Opportunity", for: UIControl.State.normal)
        } else if opportunitiesData?.isStatus == "1" {
            joinOpportunityBtn.setTitle("Pending Approval", for: UIControl.State.normal)
            joinOpportunityBtn.isUserInteractionEnabled = false
        } else if opportunitiesData?.isStatus == "2" {
            joinOpportunityBtn.isUserInteractionEnabled = false
            joinOpportunityBtn.setTitle("Accepted Opportunity", for: UIControl.State.normal)
            markEventButton.isHidden = false
            markEventButton.isUserInteractionEnabled = true
        }
    }
    
    func saveEvent() {
        let eventStore = EKEventStore()
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event = EKEvent(eventStore: eventStore)
                
                event.title = self.opportunitiesData?.title
                
                let startWeek = self.getDate(date: self.opportunitiesData?.startTimeForAddEvent ?? "") //self.getDate(date: (self.opportunitiesData?.startDate ?? "")) //+ "," + self.stringToDate(time: (opportunitiesData?.startTime ?? ""))  // Date().startOfWeek
                let endWeek = self.getDate(date: (self.opportunitiesData?.endTimeForAddEvent ?? "")) // Date().endOfWeek
                print("startWeek", startWeek)
                print("endWeek", endWeek)
                event.startDate = startWeek
                event.endDate = endWeek
                event.notes = "Event Details Here hhhgjhg"
                event.calendar = eventStore.defaultCalendarForNewEvents
                var event_id = ""
                do {
                    try eventStore.save(event, span: .thisEvent)
                    event_id = event.eventIdentifier
                }
                catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                }
                if(event_id != "") {
                    print("event added !")
                    DispatchQueue.main.async {
                        showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Event added successfully." , okButton: "OK", controller: self) {
                            
                        }
                    }
                }
            }
        })
    }
    
    func getDate(date: String) -> Date {
        let oppDate = Double(date)!
        let date = Date(timeIntervalSince1970: oppDate)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "EST") //en_US_POSIX
        dateFormatter.timeZone = .current
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC -5")
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm" //"MM-dd-yyyy hh:mm"
        print("\(date)")
        return date
    }
    
    func secondsToHoursMinutesSeconds(seconds: String) -> (Double, Double, Double) {
        let oppDate = Double(seconds)!
      let (hr,  minf) = modf(oppDate / 3600)
      let (min, secf) = modf(60 * minf)
        print(hr)
        print(min)
      return (hr, min, 60 * secf)
    }
    
    //MARK: - Request for Join Opportunity Api's
    func hitJoinOpportunitiesApi() {
        var opportunitiesResponse : OpportunitiesAllResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .joinOpportunities)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in

            opportunitiesResponse = self.getApiResponse(response: response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = opportunitiesResponse?.message // response["message"] as? String ?? ""
            if let status = opportunitiesResponse?.status {   // response["status"] as? Int {
                if status == 200 {
//                    self.pop()
//                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
//                        self.pop()
//                    }
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
    
    func generatingParams() -> [String:Any] {
        var params : [String:Any] = [:]
        let authToken  = getSAppDefault(key: DefaultKeys.authToken) as? String ?? ""
        params["authToken"] = authToken
        params["opID"] = opportunitiesData?.opID
        print("params =>", params)
        return params
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func joinOpportunityBtn(_ sender: UIButton) {
        if opportunitiesData?.isStatus == "0" || opportunitiesData?.isStatus == "3" {
            joinOpportunityBtn.setTitle("Pending Approval", for: UIControl.State.normal)
            hitJoinOpportunitiesApi()
        }
    }
    
    @IBAction func markEventButtonAction(_ sender: Any) {
        if opportunitiesData?.isStatus == "2" {
            //            self.popActionAlert(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to save event in calendar?", actionTitle: ["Ok","Cancel"], actionStyle: [.default, .cancel], action: [{ [self] ok in
            //                saveEvent()
            //            },{
            //                cancel in
            //                self.dismiss(animated: false, completion: nil)
            //            }])
            saveEvent()
        }
    }
    
    
}
