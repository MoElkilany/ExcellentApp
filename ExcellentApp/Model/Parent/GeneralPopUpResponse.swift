//
//  GeneralPopUpResponse.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 01/08/2021.
//

import Foundation
struct GeneralPopUpResponse: Codable {
    let isSuccess: Bool?
    let Message: String?
    let Status: Int?
    let data :[GeneralPopUpModel]?
}
struct GeneralPopUpModel: Codable {
    let Name:String?
    let Id:Int?
}
