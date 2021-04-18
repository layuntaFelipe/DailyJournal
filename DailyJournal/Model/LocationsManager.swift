//
//  LocationsModel.swift
//  WeatherApp
//
//  Created by Felipe Lobo on 29/03/21.
//

import Foundation
import CoreLocation

protocol LocationsManagerDelegate {
    func didUpdateView(_ locationManager: LocationsManager,locationWeather: LocationModel)
    func didFailWithError(error: Error)
}

struct LocationsManager {
    
    var delegate: LocationsManagerDelegate?
    
    let locationURL = "https://api.openweathermap.org/data/2.5/weather?&appid=\(KeysAPIs().weather)&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(locationURL)&q=\(cityName)"
        performRequest(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(locationURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let locationWeather = parseJSON(safeData) {
                        delegate?.didUpdateView(self, locationWeather: locationWeather)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> LocationModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LocationData.self, from: weatherData)
            print(decodedData)
            let cityName = decodedData.name
            let timezone = decodedData.timezone
            let temperature = decodedData.main.temp
            let feels = decodedData.main.feels_like
            let min = decodedData.main.temp_min
            let max = decodedData.main.temp_max
            let description = decodedData.weather[0].description
            let word = decodedData.weather[0].main
            let country = decodedData.sys.country
            let sunRise = decodedData.sys.sunrise
            let sunSet = decodedData.sys.sunset
            let pressure = decodedData.main.pressure
            let humidity = decodedData.main.humidity
            let windSpeed = decodedData.wind.speed
            let allClouds = decodedData.clouds.all
            let locWeatherID = decodedData.weather[0].id
            
            let location = LocationModel(cityName: cityName, timeZone: timezone, temperature: temperature, feels: feels, min: min, max: max, description: description, word: word, sunRise: sunRise, sunSet: sunSet, country: country, pressure: pressure, humidity: humidity, windSpeed: windSpeed, allClouds: allClouds, locWeatherID: locWeatherID)
            
            print(location.temperatureString)
            return location
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
