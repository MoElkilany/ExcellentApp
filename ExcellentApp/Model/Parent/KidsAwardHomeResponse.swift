//
//  KidsAwardHomeResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 11/08/2021.
//

import Foundation

struct KidsAwardHomeResponse: Codable {
    let pagesCount, status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [KidsAwardHomeModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - Datum
struct KidsAwardHomeModel: Codable {
    let id: Int?
    let kidName: String?
    let profileImageURL: String?
    let pointsObtained: Int?
    let reason: String?
    let kidsProfileID: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case kidName = "KidName"
        case profileImageURL = "profileImageUrl"
        case pointsObtained = "PointsObtained"
        case reason = "Reason"
        case kidsProfileID = "KidsProfileId"
    }
}

