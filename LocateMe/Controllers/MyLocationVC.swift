//
//  MyLocationVCViewController.swift
//  LocateMe
//
//  Created by Omar Ahmed on 17/07/2022.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - Add trip protocol

protocol AddTripDelegate: AnyObject {
    func addTrip(trip: Trip)
}


class MyLocationVC: UIViewController{
    
    //MARK: - Properities

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var startTripButton: UIButton!
    
    @IBOutlet weak var recordLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    var isStarted = false
    
    var startLocation: CLLocation?
    
    var lastLocation: CLLocation?
    
    var trackArray: [CLLocation] = []
    
    weak var delegate: AddTripDelegate?
        
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTripButton.layer.cornerRadius = 5
        configureLocationManager()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func makeTripAction(_ sender: Any) {
        isStarted.toggle()
        
        let startTrip = Location(longitude: trackArray.first!.coordinate.longitude, latitude: trackArray.first!.coordinate.latitude)
        let endTrip = Location(longitude: trackArray.last!.coordinate.longitude, latitude: trackArray.last!.coordinate.latitude)
        let trip = Trip(start: startTrip, end: endTrip)
        
        if isStarted{
            locationManager.startUpdatingLocation()
            configureView()
        }else{
            locationManager.stopUpdatingLocation()
            let region = MKCoordinateRegion(center: lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 23.3424, longitude: 26.3242), latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            configureView()
            delegate?.addTrip(trip: trip)
            print(trip)
        }
    }
    
    func configureView(){
        if isStarted{
            recordLabel.text = "Recording trip..."
            startTripButton.setTitle("Stop", for: .normal)
        }else{
            recordLabel.text = "Begin record"
            startTripButton.setTitle("Start", for: .normal)
        }
    }
    
    func configureLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
        if isLocationServiceEnabled(){
            checkAuthorization()
        }else{
            settingsAlert()
        }
    }
    
    
    func zoomToUserLocation(location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
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
            settingsAlert()
//            showAlert(messege: "Please Authorise access to location")
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
    
}

// MARK: - Extention to CLLocationManagerDelegate

extension MyLocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        startLocation = locations.first
        if let location = locations.last {
            print("Location: \(location)")
            zoomToUserLocation(location: location)
            lastLocation = location
        }
        trackArray = locations
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
