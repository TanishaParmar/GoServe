//
//  SettingListCell.swift
//  GoServe
//
//  Created by Dharmani Apps on 29/12/21.
//

import UIKit

class SettingListCell: UITableViewCell {
    
//    MARK: OUTLETS
    
    @IBOutlet weak var lblCell: UILabel!
    @IBOutlet weak var imgcell: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
