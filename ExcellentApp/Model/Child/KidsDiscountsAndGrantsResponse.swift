//
//  KidsDiscountsResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 11/10/2021.
//

import Foundation

// MARK: - KidsDiscountsAndGrantsResponse
struct KidsDiscountsAndGrantsResponse: Codable {
    let pagesCount, count, status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [KidsDiscountsAndGrantsModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case count = "Count"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - KidsDiscountsAndGrantsModel
struct KidsDiscountsAndGrantsModel: Codable {
    let pointsObtained: Int?
    let reason, createdDate: String?

    enum CodingKeys: String, CodingKey {
        case pointsObtained = "PointsObtained"
        case reason = "Reason"
        case createdDate = "CreatedDate"
    }
}
