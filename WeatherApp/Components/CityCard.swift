//
//  CityCard.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import SwiftUI

struct CityCard: View {
    var temperatureUnit: TemperatureUnit
    var model: WeatherModel?
    
    init(temperatureUnit: TemperatureUnit, model: WeatherModel? = nil) {
        self.temperatureUnit = temperatureUnit
        self.model = model
    }
    
    var body: some View {
        HStack {
            if let model = model {
                VStack(alignment: .leading, spacing: 0) {
                    Text(model.cityName)
                        .font(Font.system(size: 18, weight: .bold))
                    HStack {
                        Image(uiImage: model.icon)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(model.weatherDetails.first?.description ?? "")
                    }
                }
                Spacer()
                Text(model.main.temp.tempFormatter(unit: temperatureUnit))
                    .font(Font.system(size: 18, weight: .semibold))
                VStack {
                    HStack {
                        Text(model.main.maxTemp.tempFormatter(unit: temperatureUnit))
                        Image(systemName: "arrow.up.circle")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    HStack {
                        Text(model.main.minTemp.tempFormatter(unit: temperatureUnit))
                        Image(systemName: "arrow.down.circle")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
            } else {
                ProgressView().frame(maxWidth: .infinity)
            }
            
        }
        .roundedBorderStyle()
        
    }
}

struct CityCard_Previews: PreviewProvider {
    static var previews: some View {
        CityCard(temperatureUnit: TemperatureUnit.celcius)
    }
}
