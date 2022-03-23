//
//  GetAllReportReasonsModel.swift
//  GoServe
//
//  Created by MyMac on 1/21/22.
//

import Foundation
struct GetAllReportReasonsModel : Codable {
	let status : Int?
	let message : String?
	let getAllReportReasonData : [GetAllReportReasonData]?

	enum CodingKeys: String, CodingKey {
		case status = "status"
		case message = "message"
		case getAllReportReasonData = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
        getAllReportReasonData = try values.decodeIfPresent([GetAllReportReasonData].self, forKey: .getAllReportReasonData)
	}

}


struct GetAllReportReasonData : Codable {
    let reasonId : String?
    let reportReasons : String?

    enum CodingKeys: String, CodingKey {

        case reasonId = "reasonId"
        case reportReasons = "reportReasons"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reasonId = try values.decodeIfPresent(String.self, forKey: .reasonId)
        reportReasons = try values.decodeIfPresent(String.self, forKey: .reportReasons)
    }

}
