//
//  WeekendListCell.swift
//  GoServe
//
//  Created by Dharmani Apps on 28/12/21.
//

import UIKit

class WeekendListCell: UICollectionViewCell {
    
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var weekLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiupdate()
    }
    
    func uiupdate(){
        weekLbl.textColor = #colorLiteral(red: 0.01176180784, green: 0.01176637318, blue: 0.01176151913, alpha: 1)
        weekView.backgroundColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
        weekView.layer.borderColor = #colorLiteral(red: 0.6474128962, green: 0.643707633, blue: 0.6548088789, alpha: 1)
        weekView.layer.borderWidth = 0.5
    }
    
}
