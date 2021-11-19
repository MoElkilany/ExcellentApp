//
//  HomeParentModel.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 02/08/2021.
//

import Foundation

struct HomeParentResponse: Codable {
    let PagesCount, Status: Int?
    let Message: String?
    let IsSuccess: Bool?
    let data: [HomeParentModel]?

//    enum CodingKeys: String, CodingKey {
//        case pagesCount = "PagesCount"
//        case status = "Status"
//        case message = "Message"
//        case isSuccess = "IsSuccess"
//        case data
//    }
}

// MARK: - Datum
struct HomeParentModel: Codable {
    let Id: Int?
    let FullName, profileImageUrl: String?
    let CompletionRate: Int?

//    enum CodingKeys: String, CodingKey {
//        case id = "Id"
//        case fullName = "FullName"
//        case profileImageURL = "profileImageUrl"
//        case completionRate = "CompletionRate"
//    }
}
