//
//  OrganizationDetailVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 29/12/21.
//

import UIKit

class OrganizationDetailVC: BaseVC {
    
//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var organizationImg: UIImageView!
    @IBOutlet weak var organizationTitleLbl: UILabel!
    @IBOutlet weak var organizationDetailLbl: UILabel!
    

    var orgDetails: OrganizationDetails?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        var imgUrl = orgDetails?.orgImage ?? ""
        let placeHolder = UIImage(named: "detailedScreenPlaceHolder")
        imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        organizationImg.sd_setImage(with: URL(string: imgUrl), placeholderImage: placeHolder)
        organizationTitleLbl.text = orgDetails?.orgTitle
        organizationDetailLbl.text = orgDetails?.orgDescription
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
    }


}
