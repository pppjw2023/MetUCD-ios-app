//
//  WeatherViewModel.swift
//  MetUCD
//
//  Created by Instructor on 20/09/2023.
//

import SwiftUI
import CoreLocation

@Observable class WeatherViewModel {
    var namedLocation: String = ""
    
    // MARK: Model
    
    private var dataModel = WeatherDataModel()

    // MARK: User intent
    
    func fetchData() {
        Task {
            await dataModel.fetch(for: namedLocation)
        }
    }
    
    // MARK: Public Properties

    var geoData: String? { dataModel.geoLocationData?.description }
}
