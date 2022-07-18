//
//  MyLocationVCViewController.swift
//  LocateMe
//
//  Created by Omar Ahmed on 17/07/2022.
//

import UIKit
import MapKit
import CoreLocation

class MyLocationVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
        if isLocationServiceEnabled(){
            checkAuthorization()
        }else{
            settingsAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Location: \(location)")
            zoomToUserLocation(location: location)
        }
    }
    
    func zoomToUserLocation(location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    
    func isLocationServiceEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    
    func checkAuthorization(){
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .restricted:
            showAlert(messege: "Authorization restricted")
            break
        case .denied:
            showAlert(messege: "Please Authorise access to location")
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        @unknown default:
            print("Default")
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            settingsAlert()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .notDetermined:
            print("Not Determined")
            break
        case .restricted:
            print("Restricted")
            break
        @unknown default:
            print("Default")
            break
        }
        
    }

}
