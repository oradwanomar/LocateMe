//
//  TripService.swift
//  LocateMe
//
//  Created by Omar Ahmed on 20/07/2022.
//

import Foundation
import Firebase


struct TripService{
    
    static func uploadTrip(trip: Trip,completion: @escaping (Error?) -> Void){
        let tripData = ["startLongitude": trip.start.longitude,
                        "startLatitude": trip.start.latitude,
                        "endLongitude": trip.end.longitude,
                        "endLatitude": trip.end.latitude] as [String:Double]
        
        Firestore.firestore().collection("trips").addDocument(data: tripData, completion: completion)
    }
    
    static func fetchTrips(completion: @escaping ([Trip]) -> ()){
        
    }
    
}
