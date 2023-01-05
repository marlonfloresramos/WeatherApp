//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    func testIsValidWeatherEndpointByCoordinates() {
        let endpoint = WeatherEndpoint.getWeatherByCoordinates(lat: "30", lon: "30")
        XCTAssertEqual(endpoint.scheme, "https", "The scheme should be 'https'")
        XCTAssertEqual(endpoint.host, "api.openweathermap.org", "The api host should be 'api.openweathermap.org'")
        XCTAssertEqual(endpoint.path, "/data/2.5/weather", "The path should be '/data/2.5/weather'")
        XCTAssertEqual(endpoint.methodType.rawValue, "GET", "The httpMethod should be 'GET'")
    }
    
    func testIsValidWeatherEndpointByCity() {
        let endpoint = WeatherEndpoint.getWeatherByCity(city: "Lima")
        XCTAssertEqual(endpoint.scheme, "https", "The scheme should be 'https'")
        XCTAssertEqual(endpoint.host, "api.openweathermap.org", "The api host should be 'api.openweathermap.org'")
        XCTAssertEqual(endpoint.path, "/data/2.5/weather", "The path should be '/data/2.5/weather'")
        XCTAssertEqual(endpoint.methodType.rawValue, "GET", "The httpMethod should be 'GET'")
    }
    
    func testIsValidWeatherEndpointIcon() {
        let endpoint = WeatherEndpoint.getWeatherIcon(iconType: "10d")
        XCTAssertEqual(endpoint.scheme, "https", "The scheme should be 'https'")
        XCTAssertEqual(endpoint.host, "openweathermap.org", "The api host should be 'openweathermap.org'")
        XCTAssertEqual(endpoint.path, "/img/w/10d.png", "The path should be '/img/w/10d.png'")
        XCTAssertEqual(endpoint.methodType.rawValue, "GET", "The httpMethod should be 'GET'")
    }
}
