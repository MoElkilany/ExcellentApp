//
//  ParentKids.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 08/08/2021.
//

import Foundation
struct ParentKidsResponse: Codable {
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [ParentKidsModel]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - Datum
struct ParentKidsModel: Codable {
    let fullName: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case fullName = "FullName"
        case id = "Id"
    }
}
