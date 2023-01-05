//
//  APIClient.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 30/12/22.
//

import Foundation
import SwiftUI

enum MethodType: String {
    case GET
    case POST
}

protocol EndpointRepresentable {
    var scheme: String { get }
    var host: String { get }
    var methodType: MethodType { get }
    var path: String { get }
    var queryItems: [String: String]? { get }
}

enum WeatherEndpoint: EndpointRepresentable {
    case getWeatherByCity(city: String)
    case getWeatherByCoordinates(lat: String, lon: String)
    case getWeatherIcon(iconType: String)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        switch self {
        case .getWeatherByCity, .getWeatherByCoordinates:
            return "api.openweathermap.org"
        case .getWeatherIcon:
            return "openweathermap.org"
        }
        
    }
    
    var methodType: MethodType {
        switch self {
        case .getWeatherByCity, .getWeatherIcon, .getWeatherByCoordinates:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .getWeatherByCity, .getWeatherByCoordinates:
            return "/data/2.5/weather"
        case .getWeatherIcon(let iconType):
            return "/img/w/\(iconType).png"
        }
    }
    
    var queryItems: [String: String]? {
        let appId = ""
        switch self {
        case .getWeatherByCity(let city):
            return [
                "appid": appId,
                "q": city,
                "units": "metric"
            ]
        case .getWeatherByCoordinates(let lat, let lon):
            return [
                "appid": appId,
                "lat": lat,
                "lon": lon,
                "units": "metric"
            ]
        case .getWeatherIcon:
            return nil
        }
    }
}

final class APIClient {
    
    static func apiRequest<T: Codable>(_ type: T.Type, urlRequest: URLRequest) async throws -> T? {
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        print(data.prettyPrintedJSONString)
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw URLError(.cannotDecodeRawData)
        }
    }
    
    static func urlRequestBuilder(endPoint: EndpointRepresentable) -> URLRequest? {
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.host
        components.path = endPoint.path
        if let queryItems = endPoint.queryItems {
            components.queryItems = queryItems.map{URLQueryItem(name: $0, value: $1) }
        }
        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 5
        urlRequest.httpMethod = endPoint.methodType.rawValue
        return urlRequest
    }
    
    static func weatherRequest(city: String) async throws -> WeatherModel? {
        
        guard let urlRequest = urlRequestBuilder(endPoint: WeatherEndpoint.getWeatherByCity(city: city)) else { throw URLError(.fileDoesNotExist)}
        do {
            var model = try await apiRequest(WeatherModel.self, urlRequest: urlRequest)
            let iconType = model?.weatherDetails.first?.icon ?? ""
            if let imageUrlRequest = urlRequestBuilder(endPoint: WeatherEndpoint.getWeatherIcon(iconType: iconType)) {
                let (imageData, _) = try await URLSession.shared.data(for: imageUrlRequest)
                model?.iconData = imageData
            }
            return model
        } catch let error {
            throw error
        }
        
    }
    
    static func weatherRequest(lat: Double, lon: Double) async throws -> WeatherModel? {
        guard let urlRequest = urlRequestBuilder(endPoint: WeatherEndpoint.getWeatherByCoordinates(lat: String(lat), lon: String(lon))) else { throw URLError(.fileDoesNotExist)}
        do {
            var model = try await apiRequest(WeatherModel.self, urlRequest: urlRequest)
            let iconType = model?.weatherDetails.first?.icon ?? ""
            if let imageUrlRequest = urlRequestBuilder(endPoint: WeatherEndpoint.getWeatherIcon(iconType: iconType)) {
                let (imageData, _) = try await URLSession.shared.data(for: imageUrlRequest)
                model?.iconData = imageData
            }
            return model
        } catch let error {
            throw error
        }
    }
}
