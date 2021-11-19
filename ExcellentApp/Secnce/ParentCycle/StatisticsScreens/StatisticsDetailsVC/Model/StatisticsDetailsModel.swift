//
//  StatisticsDetailsModel.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 12/09/2021.
//

import Foundation

struct StatisticsDetailsResponse :Codable {
    let pagesCount, count,points,status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [StatisticsDetailsModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case count = "Count"
        case points = "Points"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

struct StatisticsDetailsModel: Codable {
    let taskID,giftPricePoints ,Id ,PointsObtained: Int?
    let taskTitle, taskImageURL ,giftName ,Reason: String?
    let executedCount: Int?

    enum CodingKeys: String, CodingKey {
        case taskID = "TaskId"
        case taskTitle = "TaskTitle"
        case taskImageURL = "taskImageUrl"
        case giftPricePoints = "GiftPricePoints"
        case giftName = "GiftName"
        case executedCount ,Id,Reason,PointsObtained
    }
}
