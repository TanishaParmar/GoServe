//
//  NotificationListCell.swift
//  GoServe
//
//  Created by Dharmani Apps on 27/12/21.
//

import UIKit

class NotificationListCell: UITableViewCell {
    
//    MARK: OUTLETS
    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var notificationTitleLbl: UILabel!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCell.layer.cornerRadius = imgCell.frame.height/2
        imgCell.clipsToBounds = true
        imgCell.layer.borderWidth = 1
        imgCell.layer.borderColor = #colorLiteral(red: 0.01873264089, green: 0.2946584523, blue: 0.5724223256, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
