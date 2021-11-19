//
//  GetKidActivitiesOnProfileResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import Foundation

struct GetKidActivitiesOnProfileResponse: Codable {
    let pagesCount, status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [GetKidActivitiesOnProfileModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}


struct GetKidActivitiesOnProfileModel: Codable {
    let taskTitle: String?
    let points, taskID: Int?
    let taskImage: String?

    enum CodingKeys: String, CodingKey {
        case taskTitle = "TaskTitle"
        case points = "Points"
        case taskID = "TaskId"
        case taskImage = "TaskImage"
    }
}
