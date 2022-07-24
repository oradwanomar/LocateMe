//
//  TripService.swift
//  LocateMe
//
//  Created by Omar Ahmed on 20/07/2022.
//

import Foundation
import Firebase

protocol tripServiceProtocol{
    func uploadTrip(trip: Trip,completion: @escaping (Error?)-> Void)
    func fetchTrips(completion: @escaping ([Trip])-> ())
}


struct TripService: tripServiceProtocol{
    
    static let shared = TripService()
    
    func uploadTrip(trip: Trip,completion: @escaping (Error?) -> Void){
        let tripData = ["startLongitude": trip.start.longitude,
                        "startLatitude": trip.start.latitude,
                        "endLongitude": trip.end.longitude,
                        "endLatitude": trip.end.latitude,
                        "timestamp": Timestamp(date: Date())] as [String:Any] 
        
        Firestore.firestore().collection("trips").addDocument(data: tripData, completion: completion)
    }
    
    func fetchTrips(completion: @escaping ([Trip]) -> ()){
        var trips: [Trip] = []
        Firestore.firestore().collection("trips").order(by: "timestamp").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            documents.forEach { document in
                let dic = document.data()
                let startLong = dic["startLongitude"] as? Double ?? 0.0
                let startLat = dic["startLatitude"] as? Double ?? 0.0
                let endLong = dic["endLongitude"] as? Double ?? 0.0
                let endLat = dic["endLatitude"] as? Double ?? 0.0
                let time = dic["timestamp"] as? Timestamp ?? Timestamp(date: Date())

                let trip = Trip(start: Location(longitude: startLong,latitude: startLat)
                                , end: Location(longitude: endLong, latitude: endLat), timeStamp: time)
                
                trips.append(trip)
            }
            completion(trips)
        }
    }
    
}
