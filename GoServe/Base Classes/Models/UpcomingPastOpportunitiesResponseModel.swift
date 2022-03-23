//
//  UpcomingPastOpportunitiesResponseModel.swift
//  GoServe
//
//  Created by MyMac on 1/25/22.
//

import Foundation
struct UpcomingPastOpportunitiesResponseModel : Codable {
	let status : Int?
	let message : String?
	let lastPage : Bool?
	let upcomingPastOpportunitiesData : [UpcomingPastOpportunitiesData]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case lastPage = "lastPage"
		case upcomingPastOpportunitiesData = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		lastPage = try values.decodeIfPresent(Bool.self, forKey: .lastPage)
        upcomingPastOpportunitiesData = try values.decodeIfPresent([UpcomingPastOpportunitiesData].self, forKey: .upcomingPastOpportunitiesData)
	}

}



struct UpcomingPastOpportunitiesData : Codable {
    let opID : String?
    let title : String?
    let description : String?
    let orgID : String?
    let opHour : String?
    let startDate : String?
    let endDate : String?
    let startTime : String?
    let endTime : String?
    let isDisable : String?
    let created : String?
    let opImage : String?
    let lat : String?
    let log : String?
    let opAddress : String?
    let opCreatedBy : String?
    let peopleRequired : String?
    let isStatus : String?
    let email : String?
    let startDateInDate : String?
    let endDateInDate : String?
    let dayDiff : String?

    enum CodingKeys: String, CodingKey {

        case opID = "opID"
        case title = "title"
        case description = "description"
        case orgID = "orgID"
        case opHour = "opHour"
        case startDate = "startDate"
        case endDate = "endDate"
        case startTime = "startTime"
        case endTime = "endTime"
        case isDisable = "isDisable"
        case created = "created"
        case opImage = "opImage"
        case lat = "lat"
        case log = "log"
        case opAddress = "opAddress"
        case opCreatedBy = "opCreatedBy"
        case peopleRequired = "peopleRequired"
        case isStatus = "isStatus"
        case email = "email"
        case startDateInDate = "startDateInDate"
        case endDateInDate = "endDateInDate"
        case dayDiff = "dayDiff"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        opID = try values.decodeIfPresent(String.self, forKey: .opID)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        orgID = try values.decodeIfPresent(String.self, forKey: .orgID)
        opHour = try values.decodeIfPresent(String.self, forKey: .opHour)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
        isDisable = try values.decodeIfPresent(String.self, forKey: .isDisable)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        opImage = try values.decodeIfPresent(String.self, forKey: .opImage)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        log = try values.decodeIfPresent(String.self, forKey: .log)
        opAddress = try values.decodeIfPresent(String.self, forKey: .opAddress)
        opCreatedBy = try values.decodeIfPresent(String.self, forKey: .opCreatedBy)
        peopleRequired = try values.decodeIfPresent(String.self, forKey: .peopleRequired)
        isStatus = try values.decodeIfPresent(String.self, forKey: .isStatus)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        startDateInDate = try values.decodeIfPresent(String.self, forKey: .startDateInDate)
        endDateInDate = try values.decodeIfPresent(String.self, forKey: .endDateInDate)
        dayDiff = try values.decodeIfPresent(String.self, forKey: .dayDiff)
    }

}
