//
//  AddLocationView.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 2/01/23.
//

import SwiftUI

struct AddLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddLocationViewModel
    let callBack: (String) -> ()

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 10)
            Text("Add Location")
            TextField("Enter a city name", text: $viewModel.location, onCommit: {
                viewModel.saveRecentSearch()
                callBack(viewModel.location)
                presentationMode.wrappedValue.dismiss()
            })
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled()
            if viewModel.recentSearches.count > 0 {
                HStack {
                    Text("Recent searches")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("clear") {
                        withAnimation {
                            viewModel.recentSearches.removeAll()
                            viewModel.updateRecentSearches()
                        }
                    }
                }
                List{
                    ForEach(viewModel.recentSearches, id: \.self) { city in
                        Text(city)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                callBack(city)
                                presentationMode.wrappedValue.dismiss()
                            }
                    }.onDelete { indexSet in
                        viewModel.recentSearches.remove(atOffsets: indexSet)
                        viewModel.updateRecentSearches()
                    }
                }.listStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.retrieveRecentSearches()
        }
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(viewModel: AddLocationViewModel(recentSearches: ["Lima", "Arequipa"])) {_ in }
    }
}
