//
//  ChildLoadingData.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import Foundation

// MARK: - Welcome
struct ChildLoadingDataResponse: Codable {
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: ChildLoadingDataModel?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - DataClass
struct ChildLoadingDataModel: Codable {
    let fullName, identityNumber, password, qrcode: String?

    enum CodingKeys: String, CodingKey {
        case fullName = "FullName"
        case identityNumber = "IdentityNumber"
        case password = "Password"
        case qrcode = "Qrcode"
    }
}
