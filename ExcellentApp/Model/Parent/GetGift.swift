//
//  GitGift.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 10/08/2021.
//

import Foundation

struct GetGiftResponse: Codable {
    let pagesCount, status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [GetGiftModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

struct GetGiftModel: Codable {
    let id: Int?
    let giftName: String?
    let imageURL: String?
    let giftPricePoints: Int?
    let kids: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case giftName = "GiftName"
        case imageURL = "ImageUrl"
        case giftPricePoints = "GiftPricePoints"
        case kids
    }
}


