//
//  Extensions.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import SwiftUI

// MARK: - View
extension View {
    func roundedBorderStyle() -> some View {
        self.padding(20)
            .background(RoundedRectangle(cornerRadius: 20)
                .fill(Color("primary"))
                .shadow(color: Color("secondary"), radius: 4)
            )
            .padding(.horizontal, 10)
        
    }
}

// MARK: - Array
extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

// MARK: - UserDafaults
extension UserDefaults {
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName)
    }
}

extension UserDefaults {
    func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
}

// MARK: - Data
extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

// MARK: - Double
enum TemperatureUnit {
    case celcius
    case fahrenheit
    
}

extension Double {
    func tempFormatter(unit: TemperatureUnit) -> String {
        var temperature: Double = 0
        switch unit {
        case .celcius:
            temperature = self
        case .fahrenheit:
            temperature = self.fromCelciusToF()
        }
        return String(format: "%.0f", temperature)+"°"
    }
    
    func fromCelciusToF() -> Double {
        let celsius = Measurement(value: self, unit: UnitTemperature.celsius)
        let fahrenheit = celsius.converted(to: .fahrenheit).value
        return fahrenheit
    }
    
    func fromFahrenheitToC() -> Double {
        let fahrenheit = Measurement(value: self, unit: UnitTemperature.fahrenheit)
        let celsius = fahrenheit.converted(to: .celsius).value
        return celsius
    }
}
