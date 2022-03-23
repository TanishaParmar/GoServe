//
//  PMButton.swift
//  GoServe
//
//  Created by Dharmani Apps on 23/12/21.
//

import Foundation
import UIKit

class ICBaseButton: UIButton {
    
    var fontDefaultSize : CGFloat {
        return self.titleLabel?.font.pointSize ?? 0.0
    }
    var fontSize : CGFloat = 0.0
    
    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        fontSize = getDynamicFontSize(fontDefaultSize: fontDefaultSize)
//    }
}

class ICRegularButton: ICBaseButton {
    
    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        self.titleLabel?.font = ICFont.PoppinsRegular(size: self.fontSize)
//        self.imageView?.contentMode = .scaleAspectFit
//    }
}

class ICMediumButton: ICBaseButton {
    

}

class ICRememberMeButton: ICRegularButton {
    
    var isRemember: Bool = false {
        didSet {
            if isRemember {
                self.setImage(UIImage(named: Constant.check), for: .normal)
            } else {
                self.setImage(UIImage(named: Constant.uncheck), for: .normal)
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        isRemember = false
        
        let padding: CGFloat = 4
        imageEdgeInsets = UIEdgeInsets(top: padding, left: CGFloat.zero, bottom: padding, right: padding)
        
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @objc func click(_ sender: ICRememberMeButton) {
        sender.isRemember.toggle()
    }
    
    /// common lable layout
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}

