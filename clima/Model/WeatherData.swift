//
//  WeatherData.swift
//  clima
//
//  Created by Srijnasri Negi on 12/03/24.
//

struct WeatherData: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Decodable {
    let id: Int
}

struct Main: Decodable {
    let temp: Double
}
