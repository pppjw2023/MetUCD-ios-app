//
//  WeatherView.swift
//  MetUCD
//
//  Created by Instructor on 20/09/2023.
//

import SwiftUI


// MARK: - Main View

struct WeatherView: View {
    @Bindable var viewModel: WeatherViewModel
    
    var body: some View {
        Form {
            Section {
                VStack {
                    TextField(text: $viewModel.namedLocation) {
                        Text("Enter location e.g. Dublin, IE")
                    }
                    .onSubmit { viewModel.fetchData() }
                    .padding([.leading, .trailing])
                }
            } header: { Text("Search").foregroundStyle(.tint) }
            if let data = viewModel.geoData {
                Section { Text(data) } header: { Text("Geo Location").foregroundStyle(.tint) }
            }
        }
    }
}



// MARK: - Preview


#Preview {
    WeatherView(viewModel: WeatherViewModel())
}
