//
//  LocateMeTests.swift
//  LocateMeTests
//
//  Created by Omar Ahmed on 19/07/2022.
//

import XCTest
@testable import LocateMe
import Firebase

class TripServiceTests: XCTestCase {
    
    private (set) var sut: TripService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TripService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    
    func test_ErrorIsNotNilWhenPostTripIsCalled_ThenShouldUploadPostSucces() throws {
        // Given
        let promise = XCTestExpectation(description: "Post trip succes")
        var responseError: Error?
        let trip = Trip(start: Location(longitude: 22222, latitude: 22222), end: Location(longitude: 222222, latitude: 222222), timeStamp: Timestamp(date: Date()))
        
        // When
        sut.uploadTrip(trip: trip) { error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertNil(responseError)
        
    }

    func test_TripsIsNotNilWhenFetchTripsIsCalled_ThenShouldTheTripsIsComing() throws {
        // Given
        let promise = XCTestExpectation(description: "Fetch trips completed")
        var responseTrips: [Trip] = []

        // When
        sut.fetchTrips { trips in
            responseTrips = trips
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertNotNil(responseTrips)
    }

}
    
