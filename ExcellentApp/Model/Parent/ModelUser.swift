//
//  ModelUser.swift
//  Egarr
//
//  Created by Mohamed Elkilany on 4/1/21.
//

import Foundation

struct UserModelResponse :Codable {
    let isSuccess: Bool?
    let message: String?
    let status: Int?
    let token, tokenType: String?

    enum CodingKeys: String, CodingKey {
        case isSuccess = "IsSuccess"
        case message = "Message"
        case status = "Status"
        case token, tokenType
    }
}






// MARK: - Welcome
struct UserModelResponseTest: Codable {
    let message: String?
    let data: TestModel?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case data
    }
}

// MARK: - DataClass
struct TestModel: Codable {
    let status: Int?
    let isSuccess: Bool?
    let token, tokenType: String?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case isSuccess = "IsSuccess"
        case token, tokenType
    }
}


