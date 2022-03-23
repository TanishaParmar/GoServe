//
//  NotificationResponseModel.swift
//  GoServe
//
//  Created by MyMac on 2/23/22.
//


import Foundation

struct NotificationResponseModel : Codable {
	let status : Int?
	let message : String?
	let lastPage : Bool?
    let notificationData : [NotificationData]?
	let count : String?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case lastPage = "lastPage"
		case notificationData = "data"
		case count = "count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		lastPage = try values.decodeIfPresent(Bool.self, forKey: .lastPage)
        notificationData = try values.decodeIfPresent([NotificationData].self, forKey: .notificationData)
		count = try values.decodeIfPresent(String.self, forKey: .count)
	}

}


struct NotificationData : Codable {
    let notification_id : String?
    let title : String?
    let description : String?
    let notification_type : String?
    let userID : String?
    let otherUserID : String?
    let detailsID : String?
    let roleType : String?
    let notification_read_status : String?
    let created : String?
    let profileImage : String?
    let userName : String?
    let isApprove : String?
    let opportunityDetails : OpportunitiesData?
    let organizationDetails : OrganizationDetails?


    enum CodingKeys: String, CodingKey {

        case notification_id = "notification_id"
        case title = "title"
        case description = "description"
        case notification_type = "notification_type"
        case userID = "userID"
        case otherUserID = "otherUserID"
        case detailsID = "detailsID"
        case roleType = "roleType"
        case notification_read_status = "notification_read_status"
        case created = "created"
        case profileImage = "profileImage"
        case userName = "userName"
        case isApprove = "isApprove"
        case opportunityDetails = "opportunityDetails"
        case organizationDetails = "organizationDetails"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notification_id = try values.decodeIfPresent(String.self, forKey: .notification_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        notification_type = try values.decodeIfPresent(String.self, forKey: .notification_type)
        userID = try values.decodeIfPresent(String.self, forKey: .userID)
        otherUserID = try values.decodeIfPresent(String.self, forKey: .otherUserID)
        detailsID = try values.decodeIfPresent(String.self, forKey: .detailsID)
        roleType = try values.decodeIfPresent(String.self, forKey: .roleType)
        notification_read_status = try values.decodeIfPresent(String.self, forKey: .notification_read_status)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        isApprove = try values.decodeIfPresent(String.self, forKey: .isApprove)
        opportunityDetails = try values.decodeIfPresent(OpportunitiesData.self, forKey: .opportunityDetails)
        organizationDetails = try? values.decodeIfPresent(OrganizationDetails.self, forKey: .organizationDetails)
    }

}
