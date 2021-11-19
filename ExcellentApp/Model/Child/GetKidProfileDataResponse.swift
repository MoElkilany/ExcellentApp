//
//  GetKidProfileDataResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 15/10/2021.
//

import Foundation
// MARK: - GetKidProfileDataResponse
struct GetKidProfileDataResponse: Codable {
    let kidsProfileID: Int?
    let fullName: String?
    let points: Int?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case kidsProfileID = "KidsProfileId"
        case fullName = "FullName"
        case points = "Points"
        case imageURL = "ImageURL"
    }
}
