//
//  KidsGoalsAndActivity.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 09/08/2021.
//

import Foundation
struct KidsGoalsAndActivityResponse: Codable {
    let pagesCount, status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [KidsGoalsAndActivityModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - Datum
struct KidsGoalsAndActivityModel: Codable {
    let taskTitle: String?
    let points, taskID: Int?
    let taskImage: String?
    let kids: String?

    enum CodingKeys: String, CodingKey {
        case taskTitle = "TaskTitle"
        case points = "Points"
        case taskID = "TaskId"
        case taskImage = "taskImageUrl"
        case kids 
    }
}
