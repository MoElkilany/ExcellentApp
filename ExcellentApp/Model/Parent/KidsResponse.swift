//
//  KidsResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 01/08/2021.
//

import Foundation

struct KidsResponse: Codable {
    let pagesCount, status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [KidsModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}


struct KidsModel: Codable {
    let id: Int?
    let fullName, profileImageURL: String?
    let activitiesCount, goalsCount, giftsCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case fullName = "FullName"
        case profileImageURL = "profileImageUrl"
        case activitiesCount = "ActivitiesCount"
        case goalsCount = "GoalsCount"
        case giftsCount = "GiftsCount"
    }
}
