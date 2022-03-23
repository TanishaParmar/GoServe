//
//  PrivacyPolicyVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 03/01/22.
//

import UIKit

class PrivacyPolicyVC: BaseVC {
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var descriptionDataLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
    }
    
}
