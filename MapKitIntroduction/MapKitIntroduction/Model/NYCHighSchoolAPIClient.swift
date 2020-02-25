//
//  NYCHighSchoolAPIClient.swift
//  MapKitIntroduction
//
//  Created by Cameron Rivera on 2/24/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct NYCHighSchoolAPIClient{
    static let endPointURL = "https://data.cityofnewyork.us/resource/uq7m-95z8.json"
    
    static func getHighSchoolData(completion: @escaping (Result<[NYCHighSchool],NetworkError>) -> () ){
        
        guard let url = URL(string: endPointURL) else {
            completion(.failure(.badUrl(endPointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(request) { result in
            switch result{
            case .failure(let netError):
                completion(.failure(.networkClientError(netError)))
            case .success(let data):
                do {
                    let schools = try JSONDecoder().decode([NYCHighSchool].self, from: data)
                    completion(.success(schools))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
