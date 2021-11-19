//
//  GetKidGiftsResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 15/10/2021.
//

import Foundation
// MARK: - GetKidGiftsResponse
struct GetKidGiftsResponse: Codable {
    let pagesCount, count, status: Int?
    let message: String?
    let isSuccess: Bool?
    let data: [GetKidGiftsModel]?

    enum CodingKeys: String, CodingKey {
        case pagesCount = "PagesCount"
        case count = "Count"
        case status = "Status"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case data
    }
}

// MARK: - GetKidGiftsModel
struct GetKidGiftsModel: Codable {
    let id: Int?
    let giftName, imageURL: String?
    let giftPricePoints: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case giftName = "GiftName"
        case imageURL = "ImageUrl"
        case giftPricePoints = "GiftPricePoints"
    }
}
