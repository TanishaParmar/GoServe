//
//  GetProfileDataModel.swift
//  GoServe
//
//  Created by MyMac on 1/24/22.
//


import Foundation
struct GetProfileDataModel : Codable {
	let status : Int?
	let message : String?
	let profileDetails : ProfileDetails?
    
	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case profileDetails = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
        profileDetails = try values.decodeIfPresent(ProfileDetails.self, forKey: .profileDetails)
	}

}


struct ProfileDetails : Codable {
    let userID : String?
    let firstName : String?
    let lastName : String?
    let userName : String?
    let email : String?
    let password : String?
    let dob : String?
    let userRole : String?
    let created : String?
    let verificationCode : String?
    let verified : String?
    let appleToken : String?
    let googleToken : String?
    let orgID : String?
    let isRequest : String?
    let requestOrgID : String?
    let hourTracker : String?
    let profileImage : String?
    let authToken : String?
    var organizationDetails : OrganizationDetails?
    

    enum CodingKeys: String, CodingKey {

        case userID = "userID"
        case firstName = "firstName"
        case lastName = "lastName"
        case userName = "userName"
        case email = "email"
        case password = "password"
        case dob = "dob"
        case userRole = "userRole"
        case created = "created"
        case verificationCode = "verificationCode"
        case verified = "verified"
        case appleToken = "appleToken"
        case googleToken = "googleToken"
        case orgID = "orgID"
        case isRequest = "isRequest"
        case requestOrgID = "requestOrgID"
        case hourTracker = "hourTracker"
        case profileImage = "profileImage"
        case authToken = "authToken"
        case organizationDetails = "organizationDetails"
    }
    

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(String.self, forKey: .userID)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        userRole = try values.decodeIfPresent(String.self, forKey: .userRole)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        verificationCode = try values.decodeIfPresent(String.self, forKey: .verificationCode)
        verified = try values.decodeIfPresent(String.self, forKey: .verified)
        appleToken = try values.decodeIfPresent(String.self, forKey: .appleToken)
        googleToken = try values.decodeIfPresent(String.self, forKey: .googleToken)
        orgID = try values.decodeIfPresent(String.self, forKey: .orgID)
        isRequest = try values.decodeIfPresent(String.self, forKey: .isRequest)
        requestOrgID = try values.decodeIfPresent(String.self, forKey: .requestOrgID)
        hourTracker = try values.decodeIfPresent(String.self, forKey: .hourTracker)
        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage)
        authToken = try values.decodeIfPresent(String.self, forKey: .authToken)
        organizationDetails = try? values.decodeIfPresent(OrganizationDetails.self, forKey: .organizationDetails)
        
//        do {
//            organizationDetails = try values.decodeIfPresent(OrganizationDetails.self, forKey: .organizationDetails)
//        } catch DecodingError.typeMismatch {
//
//           let orgDetails = try values.decode(String.self, forKey: .organizationDetails)
//            print(orgDetails)
//        }
        
    }

}


struct OrganizationDetails : Codable {
    let orgID : String?
    let firstName : String?
    let lastName : String?
    let userName : String?
    let email : String?
    let password : String?
    let dob : String?
    let orgImage : String?
    let orgDescription : String?
    let orgTitle : String?
    let orgAddress : String?
    let isApprove : String?
    let created : String?

    enum CodingKeys: String, CodingKey {

        case orgID = "orgID"
        case firstName = "firstName"
        case lastName = "lastName"
        case userName = "userName"
        case email = "email"
        case password = "password"
        case dob = "dob"
        case orgImage = "orgImage"
        case orgDescription = "orgDescription"
        case orgTitle = "orgTitle"
        case orgAddress = "orgAddress"
        case isApprove = "isApprove"
        case created = "created"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orgID = try values.decodeIfPresent(String.self, forKey: .orgID)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        orgImage = try values.decodeIfPresent(String.self, forKey: .orgImage)
        orgDescription = try values.decodeIfPresent(String.self, forKey: .orgDescription)
        orgTitle = try values.decodeIfPresent(String.self, forKey: .orgTitle)
        orgAddress = try values.decodeIfPresent(String.self, forKey: .orgAddress)
        isApprove = try values.decodeIfPresent(String.self, forKey: .isApprove)
        created = try values.decodeIfPresent(String.self, forKey: .created)
    }

}
