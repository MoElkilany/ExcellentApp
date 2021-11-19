//
//  ChildProfileFromParent.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 20/08/2021.
//

import Foundation

struct ChildProfileFromParentResponse: Codable {
    
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: ChildProfileFromParentModel?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - DataClass
struct ChildProfileFromParentModel: Codable {
    let id: Int?
    let fullName: String?
    let points, activitiesCount, goalsCount: Int?
    let profileImageURL: String?
    let genderID: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case fullName = "FullName"
        case points
        case activitiesCount = "ActivitiesCount"
        case goalsCount = "GoalsCount"
        case profileImageURL = "profileImageUrl"
        case genderID = "GenderId"
    }
}
