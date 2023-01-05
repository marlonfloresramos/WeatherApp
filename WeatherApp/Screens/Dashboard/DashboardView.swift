//
//  DashboardView.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject var viewModel: DashBoardViewModel
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.all)
                ScrollView {
                    Text("Current Location")
                    if let model = viewModel.currentWeatherModel {
                        CityCard(temperatureUnit: viewModel.temperatureUnit, model: model)
                    } else {
                        CityCard(temperatureUnit: viewModel.temperatureUnit)
                    }
                    if let model = viewModel.lastWeatherModel {
                        Text("Last Location")
                        CityCard(temperatureUnit: viewModel.temperatureUnit, model: model)
                    }
                    Text("Others Locations")
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.othersWeatherModelList) { element in
                            CityCard(temperatureUnit: viewModel.temperatureUnit, model: element)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.startTrackingLocation()
                viewModel.fetchOtherLocationsWeather()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "plus.magnifyingglass")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Units", selection: $viewModel.unitTag) {
                        Text("°C").tag(0)
                        Text("°F").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .sheet(isPresented: $showingSheet) {
                AddLocationView(viewModel: AddLocationViewModel()) { city in
                    viewModel.addLocation(city: city)
                }
            }
            
            .sheet(isPresented: $viewModel.showError) {
                ErrorBanner(error: viewModel.errorDescription) {
                    viewModel.startTrackingLocation()
                    viewModel.fetchOtherLocationsWeather()
                }
            }
        }
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: DashBoardViewModel())
    }
}
