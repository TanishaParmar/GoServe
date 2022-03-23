//
//  ErrorModal.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import Foundation

enum ServerError: Error {
    case InvalidURL
}

struct ErrorModal: Error {
   
    var code: Int
    var errorDescription: String
    
    init(code: Int, errorDescription: String) {
        self.code = code
        self.errorDescription = errorDescription
    }
}
