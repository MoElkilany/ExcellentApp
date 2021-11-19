//
//  Tasks.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 08/08/2021.
//

import Foundation

struct TasksResponse: Codable {
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [TasksModel]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - Datum
struct TasksModel: Codable {
    let taskID: Int?
    let taskTitle, taskTypeName: String?

    enum CodingKeys: String, CodingKey {
        case taskID = "TaskId"
        case taskTitle = "TaskTitle"
        case taskTypeName = "TaskTypeName"
    }
}
