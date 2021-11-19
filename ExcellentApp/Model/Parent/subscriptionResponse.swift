//
//  subscriptionResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import Foundation

struct subscriptionResponse: Codable {
    let id: Int?
    let typeName: String?
    let subscriptionFee: Double?
    let typeText: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case typeName = "TypeName"
        case subscriptionFee = "SubscriptionFee"
        case typeText = "TypeText"
    }
}

typealias subscriptionModel = [subscriptionResponse]
