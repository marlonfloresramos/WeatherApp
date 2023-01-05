//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 29/12/22.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: DashBoardViewModel())
        }
    }
}
