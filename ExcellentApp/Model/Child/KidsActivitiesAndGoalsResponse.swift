//
//  KidsActivitiesAndGoalsResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 11/10/2021.
//

import Foundation
// MARK: - KidsActivitiesAndGoalsResponse
struct KidsActivitiesAndGoalsResponse: Codable {
    let pagesCount, count, status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [KidsActivitiesAndGoalsModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case count = "Count"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - KidsActivitiesAndGoalsModel
struct KidsActivitiesAndGoalsModel: Codable {
    let kidsTaskID: Int?
    let taskTitle: String?
    let points: Int?
    let taskImage, createdDate: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case kidsTaskID = "KidsTaskId"
        case taskTitle = "TaskTitle"
        case points = "Points"
        case taskImage = "TaskImage"
        case createdDate = "CreatedDate"
        case status = "Status"
    }
}
