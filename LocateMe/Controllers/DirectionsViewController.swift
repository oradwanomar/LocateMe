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
    
    var trip: Trip?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let start = CLLocationCoordinate2D(latitude: (trip?.start.latitude)!, longitude: (trip?.start.longitude)!)
        let end = CLLocationCoordinate2D(latitude: (trip?.end.latitude)!, longitude: (trip?.end.longitude)!)
        mapView.delegate = self
        drawRoadDirections(startingLoc: start, destinationLoc: end)
        setStartingLocation(location: start, distance: 10000)
        addAnnotation(location: start, title: "START")
        addAnnotation(location: end, title: "END")
    }
    
    func drawRoadDirections(startingLoc: CLLocationCoordinate2D ,destinationLoc: CLLocationCoordinate2D){
        
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
    
    
    func setStartingLocation(location: CLLocationCoordinate2D ,distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation(location: CLLocationCoordinate2D, title: String){
        let pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = title
        mapView.addAnnotation(pin)
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

