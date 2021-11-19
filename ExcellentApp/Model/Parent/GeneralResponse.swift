//
//  GeneralResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import Foundation

struct GeneralResponseStringData: Codable {
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: String?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

struct GeneralResponseIntegerData: Codable {
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: String?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}
