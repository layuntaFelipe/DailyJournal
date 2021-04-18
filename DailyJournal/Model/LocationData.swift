//
//  LocationData.swift
//  DailyJournal
//
//  Created by Felipe Lobo on 30/03/21.
//

import Foundation

struct LocationData: Codable {
    let name: String
    let timezone: Int
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let wind: Wind
    let clouds: Clouds
}

struct Weather: Codable {
    let main: String
    let description: String
    let id: Int
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Int
}

struct Sys: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Wind: Codable {
    let speed: Double
}

struct Clouds: Codable {
    let all: Double
}
