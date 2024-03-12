//
//  ViewController.swift
//  clima
//
//  Created by Srijnasri Negi on 12/03/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    private var cityName = ""
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var currentLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
                
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
}

//MARK: - UITextField
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        cityName = searchTextField.text!
        searchTextField.endEditing(true)
        weatherManager.fetchData(city: cityName)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityName = textField.text!
        textField.endEditing(true)
        weatherManager.fetchData(city: cityName)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // used for validation
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}

//MARK: - WeatherManager Networking
extension WeatherViewController: weatherManagerDelegate {
    func didUpdateWeather(weatherModel: WeatherModel) {
        DispatchQueue.main.async { [weak self] in
            self?.cityLabel.text = weatherModel.cityName
            self?.temperatureLabel.text = weatherModel.temperatureString
            self?.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Core location
extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchDataForLocation(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


