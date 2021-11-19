//
//  AppContactModel.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import Foundation

// MARK: - Welcome
struct AppContactResponse: Codable {
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: AppContactModel?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - DataClass
struct AppContactModel: Codable {
    let phone, email: String?

    enum CodingKeys: String, CodingKey {
        case phone = "Phone"
        case email = "Email"
    }
}
