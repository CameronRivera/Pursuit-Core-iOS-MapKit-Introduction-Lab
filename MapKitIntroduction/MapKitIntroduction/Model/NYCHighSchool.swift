//
//  NYCHighSchool.swift
//  MapKitIntroduction
//
//  Created by Cameron Rivera on 2/24/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct NYCHighSchool: Codable {
    let schoolName: String
    let boro: String
    let overviewParagraph: String
    let phoneNumber: String
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey{
        case schoolName = "school_name"
        case boro
        case overviewParagraph = "overview_paragraph"
        case phoneNumber = "phone_number"
        case latitude
        case longitude
    }
}
