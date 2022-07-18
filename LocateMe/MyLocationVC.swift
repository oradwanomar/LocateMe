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
    
    func openSettings(alert: UIAlertAction!) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
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
    
    func showAlert(messege: String){
        let alert = UIAlertController(title: "Alert", message: messege, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func settingsAlert(){
        let alert = UIAlertController(title: "Enable Location",
                                      message: "Please Enable Location Service",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Settings",
                                      style: UIAlertAction.Style.default,
                                      handler: openSettings))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

}
