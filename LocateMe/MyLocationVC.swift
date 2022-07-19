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
    
    weak var delegate: AddTripDelegate?
    
    var tripNum = 1
    
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
        
        if isStarted{
            locationManager.startUpdatingLocation()
            let region = MKCoordinateRegion(center: startLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 23.3424, longitude: 26.3242), latitudinalMeters: 150, longitudinalMeters: 150)
            mapView.setRegion(region, animated: true)
            configureView()
        }else{
            locationManager.stopUpdatingLocation()
            let region = MKCoordinateRegion(center: lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 23.3424, longitude: 26.3242), latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            configureView()
        }
    }
    
    private func configureView(){
        if isStarted{
            recordLabel.text = "Recording trip..."
            startTripButton.setTitle("Stop", for: .normal)
        }else{
            recordLabel.text = "Begin record"
            startTripButton.setTitle("Start", for: .normal)
        }
    }
    
    private func createTrip(){
        let startTrip = Location(longitude: (startLocation?.coordinate.longitude)!, latitude: (startLocation?.coordinate.latitude)!)
        let endTrip = Location(longitude: (lastLocation?.coordinate.longitude)!, latitude: (lastLocation?.coordinate.latitude)!)
        let trip = Trip(tripNumber: tripNum, start: startTrip, end: endTrip)
        delegate?.addTrip(trip: trip)
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
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            settingsAlert()
            break
        case .authorizedAlways:
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
