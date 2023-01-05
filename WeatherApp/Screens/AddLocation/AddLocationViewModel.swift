//
//  AddLocationViewModel.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import Foundation

class AddLocationViewModel: ObservableObject {
    @Published var location: String = ""
    @Published var recentSearches: [String]
    
    init(recentSearches: [String] = []) {
        self.recentSearches = recentSearches
    }
    
    func saveRecentSearch() {
        guard location.count > 0 else { return }
        recentSearches.insert(location, at: 0)
        if recentSearches.count > 5 {
            recentSearches.removeLast()
        }
        updateRecentSearches()
    }
    
    func retrieveRecentSearches() {
        guard let searches = UserDefaults.standard.codableObject(dataType: RecentSearches.self, key: "recentSearches")?.searches else { return }
        recentSearches = searches
    }
    
    func updateRecentSearches() {
        let searches = RecentSearches(searches: recentSearches)
        UserDefaults.standard.setCodableObject(searches, forKey: "recentSearches")
    }
    
}
