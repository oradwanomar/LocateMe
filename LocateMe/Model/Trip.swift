//
//  Trip.swift
//  LocateMe
//
//  Created by Omar Ahmed on 19/07/2022.
//

import Foundation

struct Trip{
    let tripNumber: Int
    let start: Location
    let end: Location
}

struct Location{
    let longitude: Double
    let latitude: Double
}
