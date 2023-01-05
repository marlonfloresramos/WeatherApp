//
//  DashboardViewModel.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import Foundation
import SwiftUI
import CoreLocation

class DashBoardViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentWeatherModel: WeatherModel? = nil
    @Published var lastWeatherModel: WeatherModel? = nil
    @Published var othersWeatherModelList = [WeatherModel]()
    @Published var showError = false
    @Published var errorDescription = ""
    @Published var unitTag: Int = 0 {
        didSet {
            temperatureUnit = unitTag == 0 ? .celcius : .fahrenheit
        }
    }
    @Published var temperatureUnit: TemperatureUnit = .celcius
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    let locationManager = CLLocationManager()
    
    var defaultLocations = [
        "London",
        "Montevideo",
        "Buenos Aires"
    ]
    
    func fetchCurrentLocationWeather() {
        Task {
            do {
                if let model = try await APIClient.weatherRequest(lat: latitude, lon: longitude) {
                    DispatchQueue.main.async {
                        self.currentWeatherModel = model
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorDescription = error.localizedDescription
                }
            }
        }
    }
    
    func fetchLastLocationWeather() {
        guard let locationInfo = UserDefaults.standard.codableObject(dataType: LocationInfo.self, key: LocationInfo.userDefaultKey) else { return }
        guard !(latitude == locationInfo.latitude && longitude == locationInfo.longitude) else { return }
        Task {
            do {
                if let model = try await APIClient.weatherRequest(lat: locationInfo.latitude, lon: locationInfo.longitude) {
                    DispatchQueue.main.async {
                        self.lastWeatherModel = model
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorDescription = error.localizedDescription
                }
            }
            
        }
    }
    
    func fetchOtherLocationsWeather() {
        self.othersWeatherModelList.removeAll()
        Task {
            for city in defaultLocations {
                do {
                    let model = try await APIClient.weatherRequest(city: city)
                    if let model {
                        DispatchQueue.main.async {
                            self.othersWeatherModelList.append(model)
                        }
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.showError = true
                        self.errorDescription = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func fetchLocation(city: String) {
        // here we use the max length of 60 because the largest name of a city currently is 58
        guard city.count > 0 || city.count < 60 else { return }
        Task {
            do {
                let model = try await APIClient.weatherRequest(city: city)
                if let model {
                    DispatchQueue.main.async {
                        self.othersWeatherModelList.insert(model, at: 0)
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorDescription = error.localizedDescription
                }
            }
            
        }
    }
    
    func startTrackingLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func addLocation(city: String) {
        let cities = othersWeatherModelList.map { $0.cityName.lowercased() }
        guard !cities.contains(city.lowercased()) else { return }
        fetchLocation(city: city)
    }
}

extension DashBoardViewModel {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        UserDefaults.standard.setCodableObject(LocationInfo(latitude: latitude, longitude: longitude), forKey: LocationInfo.userDefaultKey)
        self.fetchLastLocationWeather()
        self.fetchCurrentLocationWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
