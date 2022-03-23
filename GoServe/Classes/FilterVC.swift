//
//  FilterVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 28/12/21.
//

import UIKit

class FilterVC: BaseVC,UITextFieldDelegate {
    
//    var weekendArr = [("Mon",false),("Tue",false),("Wed",false),("Thu",false),("Fri",false),("Sat",false),("Sun",false)]
    
    var weekendArr = [("'Mon'",false),("'Tue'",false),("'Wed'",false),("'Thu'",false),("'Fri'",false),("'Sat'",false),("'Sun'",false)]
    
//    var weekendArr = [('Mon',false),('Tue',false),('Wed',false),('Thu',false),('Fri',false),('Sat',false),('Sun',false)]


    let datePicker = UIDatePicker()

//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startdateTF: UITextField!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var weekendCollectionView: UICollectionView!
    @IBOutlet weak var applyFilterBtn: UIButton!
    var filterOppurtunitiesArr: [OpportunitiesData]?
    var selectedType: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekendCollectionView.delegate = self
        weekendCollectionView.dataSource = self
        uiUpdate()
        createDatePicker()

    }

    @IBAction func applyFilterBtn(_ sender: UIButton) {
        if validate() == false {
            return
        }
        else {
            hitFilterOpportunitiesApi()
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
            
    }
    
    
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        startdateTF.inputAccessoryView = toolbar
        endDateTF.inputAccessoryView = toolbar
        datePicker.locale = NSLocale(localeIdentifier: "en_US") as Locale // 24 hour time
        datePicker.timeZone = TimeZone(identifier: "UTC")
        startdateTF.inputView = datePicker
        endDateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func donePressed() {
        if startdateTF.isFirstResponder {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.dateFormat = "MM/dd/yyyy"
            startdateTF.text = formatter.string(from: datePicker.date)
        }
        if endDateTF.isFirstResponder{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.dateFormat = "MM/dd/yyyy"
            endDateTF.text = formatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    
    
    func uiUpdate() {
        startdateTF.delegate = self
        endDateTF.delegate = self
        startDateView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        endDateView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        startDateView.layer.borderColor = textField == startdateTF ?  #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        endDateView.layer.borderColor = textField == endDateTF ?  #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        startDateView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        endDateView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //   MARK: Validations
    func validate() -> Bool {
        
//        if ValidationManager.shared.isEmpty(text: startdateTF.text) == true {
//            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select start date." , okButton: "Ok", controller: self) {
//            }
//            return false
//        }
        
//        if ValidationManager.shared.isEmpty(text: startdateTF.text) == true && ValidationManager.shared.isEmpty(text:  endDateTF.text ) == true  {
//
//        }
        
        let days = weekendArr.filter ({$0.1 == true}).first?.1
        if ValidationManager.shared.isEmpty(text:  endDateTF.text ) == true && ValidationManager.shared.isEmpty(text: startdateTF.text) == true {
            if days == false || days == nil {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select date or day." , okButton: "Ok", controller: self) {
                }
                return false
            }
        } else if ValidationManager.shared.isEmpty(text:  endDateTF.text ) == false {
            if ValidationManager.shared.isEmpty(text: startdateTF.text) == true {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select start date." , okButton: "Ok", controller: self) {
                }
                return false
            }
        }
        return true
    }
    
    //MARK: - Filter Opportunity Api's
    func hitFilterOpportunitiesApi() {
        var opportunitiesResponse : OpportunitiesAllResponseModel?
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let url = getFinalUrl(lastComponent: .filterOpportunities)
        AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParams(), headers: nil) { response in
            opportunitiesResponse = self.getApiResponse(response: response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = opportunitiesResponse?.message
            if let status = opportunitiesResponse?.status {
                if status == 200 {
                    self.filterOppurtunitiesArr = opportunitiesResponse?.opportunitiesData
                    NotificationCenter.default.post(name: NSNotification.Name("filterResponse"), object:nil, userInfo: ["oppDetails": self.filterOppurtunitiesArr])
                    self.pop()
                }
                else if status == 403 {
                    showAlertMessage(title:AppAlertTitle.appName.rawValue, message: message ?? "" , okButton: "OK", controller: self) {
                        Globals.loginScreen()
                    }
                }
                else {
                    self.filterOppurtunitiesArr = nil
                    NotificationCenter.default.post(name: NSNotification.Name("filterResponse"), object:nil, userInfo: ["oppDetails": self.filterOppurtunitiesArr])
                    self.pop()
//                    alert(AppAlertTitle.appName.rawValue, message: message ?? "", view: self)
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
        var selectedDay = [String]()
        
        for days in weekendArr {
            if days.1 == true{
                selectedDay.append(days.0)
            }
        }
        
        let days = selectedDay.joined(separator: ",")
        print(days)
        
        switch selectedType {
        case 0:
            print("First Segment Selected")
            params["type"] = 1
        case 1:
            print("Second Segment Selected")
            params["type"] = 2
        default:
            break
        }

        params["authToken"] = authToken
        params["startDate"] = startdateTF.text
        params["endDate"] = endDateTF.text
        params["selectDay"] = days // selectedDay
        params["pageNo"] = 1
        params["perPage"] = 500
        print("params =>", params)
        return params
    }
    
    
    
}
extension FilterVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekendArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekendListCell", for: indexPath) as! WeekendListCell
        DispatchQueue.main.async {
            cell.weekView.clipsToBounds = true
        }
        cell.weekLbl.text = weekendArr[indexPath.row].0.replacingOccurrences(of: "'", with: "")
        cell.weekLbl.textColor  = weekendArr[indexPath.row].1 == true ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.01176180784, green: 0.01176637318, blue: 0.01176151913, alpha: 1)
        cell.weekView.backgroundColor = weekendArr[indexPath.row].1 == true ? #colorLiteral(red: 0.0218391642, green: 0.3246777356, blue: 0.6288291216, alpha: 1) : #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
        cell.weekView.layer.borderColor = weekendArr[indexPath.row].1 == true ? UIColor.clear.cgColor : #colorLiteral(red: 0.6474128962, green: 0.643707633, blue: 0.6548088789, alpha: 1)
        cell.weekView.layer.borderWidth = weekendArr[indexPath.row].1 == true ? 0 : 0.5
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/4, height: self.view.frame.size.height * 0.055 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        weekendCollectionView.allowsMultipleSelection = true
        weekendArr[indexPath.row].1 = !weekendArr[indexPath.row].1
        weekendCollectionView.reloadData()
    }
    
    
}
