//
//  LocationInfo.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import Foundation

struct LocationInfo: Codable {
    let latitude: Double
    let longitude: Double
    
    static let userDefaultKey = "locationInfo"
}
