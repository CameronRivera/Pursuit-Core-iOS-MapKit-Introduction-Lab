//
//  MapKitIntroductionTests.swift
//  MapKitIntroductionTests
//
//  Created by Cameron Rivera on 2/24/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import XCTest
@testable import MapKitIntroduction

class MapKitIntroductionTests: XCTestCase {
    func testNetworkHelper() {
        // Arrange
        let exp = expectation(description: "Retrieve some data")
        let urlString = "https://data.cityofnewyork.us/resource/uq7m-95z8.json"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        // Act
        NetworkHelper.shared.performDataTask(request) { result in
            switch result{
            case .failure(let netError):
                XCTFail("Could not retrieve data \(netError)")
            case .success(let data):
                // Assert
                exp.fulfill()
                XCTAssertNotNil(data)
            }
        }
        wait(for: [exp], timeout: 3.0)
    }
    
    func testNYCHighSchoolAPI() {
        // Arrange
        let expectedSchoolName = "Brooklyn High School for Law and Technology"
        let exp = expectation(description: "Retrieve high school data.")
        
        // Act
        NYCHighSchoolAPIClient.getHighSchoolData { result in
            switch result {
            case .failure(let netError):
                XCTFail("Failed to retrieve school: \(netError)")
            case .success(let schools):
                exp.fulfill()
                if let firstSchool = schools.first{
                    // Assert
                    XCTAssertEqual(firstSchool.schoolName, expectedSchoolName)
                }
            }
        }
        wait(for: [exp], timeout: 3.0)
    }
}
