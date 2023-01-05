//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import Foundation
import SwiftUI

struct WeatherModel: Codable, Identifiable {
    var id = UUID()
    var main: MainModel
    var cityName: String
    var weatherDetails: [WeatherDetail]
    var icon: UIImage = UIImage()
    var iconData: Data? {
        didSet {
            if let iconData, let image =  UIImage(data: iconData) {
                icon = image
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case main
        case cityName = "name"
        case weatherDetails = "weather"
    }
}

struct MainModel: Codable {
    var temp: Double
    var minTemp: Double
    var maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

struct WeatherDetail: Codable {
    let icon: String
    let description: String
}

