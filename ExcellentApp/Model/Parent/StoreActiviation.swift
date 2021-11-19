//
//  StoreActiviation.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import Foundation

struct ChangeStoreActiviationResponse: Codable {
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



struct ActiveStoreResponse: Codable {
    let status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: ActiveStoreData?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - DataClass
struct ActiveStoreData: Codable {
    let activateStore, isSubscriber: Bool?

    enum CodingKeys: String, CodingKey {
        case activateStore = "ActivateStore"
        case isSubscriber = "IsSubscriber"
    }
}
