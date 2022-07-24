//
//  DirectionsViewControllerTests.swift
//  LocateMeTests
//
//  Created by Omar Ahmed on 24/07/2022.
//

import XCTest
@testable import LocateMe
import MapKit

class DirectionsViewControllerTests: XCTestCase {
    
    private (set) var directions: DirectionsViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        directions = DirectionsViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        directions = nil
    }

    func test_AnnotationIsAddedWhenAddAnnotationIsCalled_ThenItDrawOnMapView() throws {
        // Given
        let mapView = MKMapView()
        let location = CLLocationCoordinate2D(latitude: 23.2324234, longitude: -122.232343)
        let pin = MKPointAnnotation()
        
        // When
        pin.coordinate = location
        mapView.addAnnotation(pin)
        
        // Then
        XCTAssertEqual(mapView.annotations.count, 1)
    }
    
    func test_DrawRoadDirectionsOnMapView() throws {
        // Given
        let startingLoc = CLLocationCoordinate2D(latitude: 23.2324234, longitude: -122.232343)
        let destinationLoc = CLLocationCoordinate2D(latitude: 23.2324234, longitude: -122.232343)
        
        let startPlace = MKPlacemark(coordinate: startingLoc)
        let destinationPlace = MKPlacemark(coordinate: destinationLoc)
        
        let startingItem = MKMapItem(placemark: startPlace)
        let destinationItem = MKMapItem(placemark: destinationPlace)
        
        let request = MKDirections.Request()
        let directions = MKDirections(request: request)

        var respnsseError: Error?

        // When
        request.source = startingItem
        request.destination = destinationItem
        request.transportType = .automobile
        
        directions.calculate { response,error in
            respnsseError = error
        }
        
        // Then
        XCTAssertNil(respnsseError)
    }

}
