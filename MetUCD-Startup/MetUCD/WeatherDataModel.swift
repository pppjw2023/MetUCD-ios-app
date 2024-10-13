//
//  WeatherDataModel.swift
//  MetUCD
//
//  Created by Instructor on 20/09/2023.
//

import Foundation

// MARK: - WeatherDataModel

struct WeatherDataModel {
    private(set) var geoLocationData: GeoLocationData?
    
    private mutating func clear() {
        geoLocationData = nil
    }
    
    mutating func fetch(for location: String) async {
        clear()
        geoLocationData = await OpenWeatherMapAPI.geoLocation(for: location, countLimit: 1)
    }
}


// MARK: - Partial support for OpenWeatherMap API 2.5 (free api access)

struct OpenWeatherMapAPI {
    #warning("Input your API Key")
    private static let apiKey = "REPLACE_WITH_YOUR_API_KEY"
    private static let baseURL = "https://api.openweathermap.org/"

    // Async fetch from OpenWeatherMap
    private static func fetch<T: Decodable>(from apiString: String, asType type: T.Type) async throws -> T {
        guard let url = URL(string: "\(Self.baseURL)\(apiString)&appid=\(Self.apiKey)") else { throw NSError(domain: "Bad URL", code: 0, userInfo: nil) }
        let (data, _) =  try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }

    // MARK: - Public API
    
    static func geoLocation(for location: String, countLimit count: Int) async -> GeoLocationData? {
        let apiString = "geo/1.0/direct?q=\(location)&limit=\(count)"
        return try? await OpenWeatherMapAPI.fetch(from: apiString, asType: GeoLocationData.self)
    }
}


// MARK: - GeoLocationData

typealias GeoLocationData = [GeoLocation]


// MARK: - GeoLocation

struct GeoLocation: Codable, CustomStringConvertible {
    let name: String // Name of the found location
    let localNames: [String: String]? // Name of the found location in different languages. The list of names can be different for different locations
    let lat, lon: Double // Geographical coordinates of the found location (latitude, longitude)
    let country: String // Country of the found location
    let state: String? // (where available) State of the found location
    
    var description: String {
        ["location: \(name), \(country)", "lat: \(lat)", "lon: \(lon)"].joined(separator: "\n")
    }
}
