//
//  Trip.swift
//  LocateMe
//
//  Created by Omar Ahmed on 19/07/2022.
//

import Foundation
import Firebase

struct Trip{
    var start: Location
    var end: Location
    let timeStamp: Timestamp
}

struct Location{
    var longitude: Double
    var latitude: Double
}
