//
//  ViewController.swift
//  LocateMe
//
//  Created by Omar Ahmed on 12/07/2022.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let start = CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417)
        let end = CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.03121860)
        mapView.delegate = self
        drawRoadDirections(startingLoc: start, destinationLoc: end)
        setStartingLocation(location: start, distance: 10000)
    }
    
    
    func drawRoadDirections(startingLoc: CLLocationCoordinate2D,destinationLoc: CLLocationCoordinate2D){
        
        let startPlace = MKPlacemark(coordinate: startingLoc)
        let destinationPlace = MKPlacemark(coordinate: destinationLoc)
        
        let startingItem = MKMapItem(placemark: startPlace)
        let destinationItem = MKMapItem(placemark: destinationPlace)
        
        let request = MKDirections.Request()
        request.source = startingItem
        request.destination = destinationItem
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response,error in
            guard let response = response else {
                if error != nil {
                    print("Directions Error")
                }
                return
            }
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
    func setStartingLocation(location: CLLocationCoordinate2D,distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }

}


// MARK: - MKMapViewDelegate

extension DirectionsViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .systemBlue
        return render
    }
}
