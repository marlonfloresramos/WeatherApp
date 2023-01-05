//
//  ErrorBanner.swift
//  WeatherApp
//
//  Created by Marlon Gabriel Flores Ramos on 4/01/23.
//

import SwiftUI

struct ErrorBanner: View {
    @Environment(\.presentationMode) var presentationMode
    let error: String
    let callBack: () -> ()
    
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.icloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(Color.red)
            Text("Oups! Something went wrong")
                .font(Font.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
            Text(error)
                .frame(maxWidth: .infinity, alignment: .center)
            Button("Retry") {
                callBack()
                presentationMode.wrappedValue.dismiss()
            }
            
        }
    }
}

struct ErrorBanner_Previews: PreviewProvider {
    static var previews: some View {
        ErrorBanner(error: "Some error description here") {}
    }
}
