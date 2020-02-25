//
//  NetworkHelper.swift
//  MapKitIntroduction
//
//  Created by Cameron Rivera on 2/24/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

class NetworkHelper {
    static let shared = NetworkHelper()
    private var session: URLSession
    
    private init(){
        session = URLSession(configuration: .default)
    }
    
    func performDataTask(_ request: URLRequest, completion: @escaping (Result<Data,NetworkError>) -> ()){
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkClientError(error)))
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            switch httpURLResponse.statusCode{
            case 200...299:
                break
            default:
                completion(.failure(.badStatusCode(httpURLResponse.statusCode)))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }
        dataTask.resume()
    }
}
