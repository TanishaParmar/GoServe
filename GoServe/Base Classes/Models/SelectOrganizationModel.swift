//
//  EditProfileDataModel.swift
//  GoServe
//
//  Created by MyMac on 1/24/22.
//


import Foundation
struct SelectOrganizationModel : Codable {
	let status : Int?
	let message : String?
	let selectOrganizationData : [SelectOrganizationData]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case selectOrganizationData = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
        selectOrganizationData = try values.decodeIfPresent([SelectOrganizationData].self, forKey: .selectOrganizationData)
	}

}

struct SelectOrganizationData : Codable {
    let orgID : String?
    let orgTitle : String?

    enum CodingKeys: String, CodingKey {

        case orgID = "orgID"
        case orgTitle = "orgTitle"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orgID = try values.decodeIfPresent(String.self, forKey: .orgID)
        orgTitle = try values.decodeIfPresent(String.self, forKey: .orgTitle)
    }

}
