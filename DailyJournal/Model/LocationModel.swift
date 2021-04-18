//
//  LocationModel.swift
//  DailyJournal
//
//  Created by Felipe Lobo on 30/03/21.
//

import Foundation
import UIKit

struct LocationModel {
    let cityName: String
    let timeZone: Int
    let temperature: Double
    let feels: Double
    let min: Double 
    let max: Double
    let description: String
    let word: String
    let sunRise: Int
    let sunSet: Int
    let country: String
    let pressure: Double
    let humidity: Int
    let windSpeed: Double
    let allClouds: Double
    let locWeatherID: Int
    
    var temperatureString: String {
        return "\(Int(temperature))º"
    }
    
    var nameCondition: String {
        switch locWeatherID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
