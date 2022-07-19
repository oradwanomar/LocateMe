//
//  ViewController.swift
//  LocateMe
//
//  Created by Omar Ahmed on 12/07/2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initLocation = CLLocation(latitude: 24.69371, longitude: 46.723596)
        setStartingLocation(location: initLocation, distance: 10000)
        addAnnotation()
    }
    
    func setStartingLocation(location: CLLocation,distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 1000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    
    func addAnnotation(){
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 24.69371, longitude: 46.723596)
        pin.title = "My title"
        pin.subtitle = "My syb title"
        mapView.addAnnotation(pin)
    }


}

