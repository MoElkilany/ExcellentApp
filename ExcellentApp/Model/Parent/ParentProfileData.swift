//
//  ParentProfileData.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 22/08/2021.
//

import Foundation
struct ParentProfileDataResponse: Codable {
    let fullName, email, mobileNumber: String?
    let genderID: Int?

    enum CodingKeys: String, CodingKey {
        case fullName = "FullName"
        case email = "Email"
        case mobileNumber = "MobileNumber"
        case genderID = "GenderId"
    }
}
