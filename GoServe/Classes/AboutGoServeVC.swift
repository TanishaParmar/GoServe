//
//  AboutGoServeVC.swift
//  GoServe
//
//  Created by Dharmani Apps on 03/01/22.
//

import UIKit

class AboutGoServeVC: BaseVC {
    
//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLBL: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
    }
}
