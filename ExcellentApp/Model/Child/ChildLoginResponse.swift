//
//  ChildLoginResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 11/10/2021.
//

import Foundation

struct ChildLoginResponse: Codable {
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
