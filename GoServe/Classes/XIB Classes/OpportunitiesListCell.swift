//
//  OpportunitiesListCell.swift
//  GoServe
//
//  Created by Dharmani Apps on 27/12/21.
//

import UIKit

class OpportunitiesListCell: UITableViewCell {
    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var attactBtn: UIButton!
    @IBOutlet weak var imgBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
