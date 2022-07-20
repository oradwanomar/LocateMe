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
    
    //MARK: - Outlets

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var startTripButton: UIButton!
    
    @IBOutlet weak var recordLabel: UILabel!
    
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    //MARK: - Properities

    
    var locationManager = CLLocationManager()
    
    var isStarted = false
    
    var startTrip: Location?
        
    var lastLocation: CLLocation?
    
    var currentSpeed: Double?
    
    var trackArray: [CLLocation] = []
    
    var timer: Timer?
    
    var stopSeconds = 0
    
    var timerCounter = 11
    
    weak var delegate: AddTripDelegate?
        
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTripButton.layer.cornerRadius = 5
        timerView.layer.cornerRadius = 35
        timerLabel.text = "\(timerCounter)"
        configureLocationManager()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        timerView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    } 
    
    //MARK: - IBActions

    
    @IBAction func makeTripAction(_ sender: Any) {
        isStarted.toggle()
        
        if isStarted{
            locationManager.startUpdatingLocation()
            startTrip = Location(longitude: trackArray.last!.coordinate.longitude, latitude: trackArray.last!.coordinate.latitude)
            configureView()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }else{
           endAndSaveTrip()
        }
    }
    
}

//MARK: - OBJC Functions

extension MyLocationVC{
    @objc func fireTimer(){
        if locationManager.location!.speed <= 0.0 {
            timerView.isHidden = false
            stopSeconds += 1
            timerLabel.text = "\(timerCounter - stopSeconds)"

            if stopSeconds == 10 {
                isStarted = false
                endAndSaveTrip()
                recordLabel.text = "Trip is stopped"
            }
        }else{
            if stopSeconds < 10 && stopSeconds > 0{
                recordLabel.text = "Still recording..."
                startTripButton.setTitle("Stop", for: .normal)
                stopSeconds = 0
            }
        }
    }
}

//MARK: - Helper Functions

extension MyLocationVC{
    
    func endAndSaveTrip(){
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        stopSeconds = 0
        timerView.isHidden = true
        
        let endTrip = Location(longitude: trackArray.last!.coordinate.longitude, latitude: trackArray.last!.coordinate.latitude)
        let trip = Trip(start: startTrip!, end: endTrip)
        delegate?.addTrip(trip: trip)
        
        zoomToUserLocation(location: lastLocation!, lat: 700, long: 700)
        
        
        configureView()
        
        trackArray.removeAll()
        locationManager.startUpdatingLocation()
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
    
    
    func zoomToUserLocation(location: CLLocation,lat: Double,long: Double){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: lat, longitudinalMeters: long)
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
        if let location = locations.last {
            print("Location: \(location)")
            zoomToUserLocation(location: location,lat: 500,long: 500)
            trackArray.append(location)
            lastLocation = location
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
