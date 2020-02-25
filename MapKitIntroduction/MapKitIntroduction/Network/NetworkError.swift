//
//  NetworkError.swift
//  MapKitIntroduction
//
//  Created by Cameron Rivera on 2/24/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

enum NetworkError: Error{
    case badUrl(String)
    case noData
    case noResponse
    case decodingError(Error)
    case encodingError(Error)
    case badStatusCode(Int)
    case networkClientError(Error)
}
