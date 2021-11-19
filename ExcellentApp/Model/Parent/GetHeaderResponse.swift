//
//  GetHeaderResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import Foundation

struct GetHeaderResponse: Codable {
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: GetHeaderModel?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - DataClass
struct GetHeaderModel: Codable {
    let points: Int?
    let ad: String?
    let notificationCount: Int?

    enum CodingKeys: String, CodingKey {
        case points = "Points"
        case ad
        case notificationCount = "NotificationCount"
    }
}
