//
//  LocationViewController.swift
//  DailyJournal
//
//  Created by Felipe Lobo on 30/03/21.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController{

    @IBOutlet weak var mainTempView: UIView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minmaxLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var tabbarView: UITabBarItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var dayLabel: UILabel!
    
    var location = LocationsManager()
    var coreLocationManager = CLLocationManager()
    var trackingTransparency = TrackingTransparency()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreLocationManager.delegate = self
        
        location.delegate = self
        searchTextField.delegate = self
        searchTextField.isHidden = true
    
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.requestLocation()
        trackingTransparency.initiateTracking()

        mainTempView.layer.cornerRadius = 20
        mainTempView.layer.shadowColor = UIColor(named: "blue")?.cgColor
        mainTempView.layer.shadowOpacity = 0.2
        mainTempView.layer.shadowOffset = CGSize(width: 10, height: 10)
        mainTempView.layer.shadowRadius = 20
        
        let day = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d y"
        dayLabel.text = formatter.string(from: day)
        
    }

    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.becomeFirstResponder()

        if let city = searchTextField.text {
            location.fetchWeather(cityName: city)
            view.endEditing(true)
        } else if searchTextField.text == "" {
            searchTextField.text = ""
            view.endEditing(true)
        }
        searchTextField.text = ""

        searchTextField.isHidden.toggle()
        
    }
    
    @IBAction func currentLocationButton(_ sender: UIButton) {
        coreLocationManager.requestLocation()
    }
    
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

//MARK: - UITextFieldDelegate

extension LocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Use searchTextField.text to get the weather for the city.
        if let city = searchTextField.text {
            location.fetchWeather(cityName: city)
            searchTextField.isHidden = true
        }
        searchTextField.text = ""
    }
    
}

//MARK: - LocationManagerDelegate
extension LocationViewController: LocationsManagerDelegate {
    
    func didUpdateView(_ locationManager: LocationsManager,locationWeather: LocationModel) {
        DispatchQueue.main.async {
            self.moodImage.image = UIImage(systemName: locationWeather.nameCondition)
            self.cityLabel.text = locationWeather.cityName
            self.tempLabel.text = locationWeather.temperatureString
            self.minmaxLabel.text = "\(String(format: "%.0f", locationWeather.min))ºc/\(String(format: "%.0f", locationWeather.max))ºc"
            self.moodLabel.text = locationWeather.description
            self.feelsLikeLabel.text = "Real Feel: \(locationWeather.feels)º"
            self.humidityLabel.text = "\(locationWeather.humidity)%"
            self.windSpeedLabel.text = "\(locationWeather.windSpeed)m/s"
            self.rainLabel.text = "\(locationWeather.allClouds)%"
            self.pressure.text = "\(locationWeather.pressure) Pa"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            coreLocationManager.stopUpdatingLocation()
            let lat = lastLocation.coordinate.latitude
            let lon = lastLocation.coordinate.longitude
            location.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

