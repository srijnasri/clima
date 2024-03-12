//
//  WeatherManager.swift
//  clima
//
//  Created by Srijnasri Negi on 12/03/24.
//

import Foundation

protocol weatherManagerDelegate {
    func didUpdateWeather(weatherModel: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager {
    
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=8e3952d4419e7492ce68b4707c645a32&units=metric"
    var delegate: weatherManagerDelegate?
    
    func fetchData(city: String) {
        let actualUrl = url + "&q=\(city)"
        performUrlRequest(url: actualUrl)
    }
    
    func fetchDataForLocation(lat: Double, lon: Double) {
        let actualUrl = url + "&lat=\(lat)&lon=\(lon)"
        performUrlRequest(url: actualUrl)
    }
    
    func performUrlRequest(url: String) {
        // create url
        if let url = URL(string: url) {
            print(url)
            // create url session
            let urlSession = URLSession(configuration: .default)
            // create a task
            let task = urlSession.dataTask(with: url) { data, response, error in
                if error == nil {
                    self.parseData(data: data)
                } else {
                    self.delegate?.didFailWithError(error: error!)
                }
            }
            // start the task
            task.resume()
        }
    }
    
    func parseData(data: Data?) {
        if let data = data {
            do {
                let jsonData = try JSONDecoder().decode(WeatherData.self, from: data)
                let weatherModel = WeatherModel(conditionId: jsonData.weather.first?.id ?? 0,
                                                cityName: jsonData.name,
                                                temperature: jsonData.main.temp)
                self.delegate?.didUpdateWeather(weatherModel: weatherModel)
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
}
