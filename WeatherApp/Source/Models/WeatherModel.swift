//
//  WeatherModel.swift
//  WeatherAppLecture
//
//  Created by Daria on 6/26/17.
//  Copyright © 2017 Daria. All rights reserved.
//

import UIKit


class WeatherModel {
    
    let city: String?
    let temperature: Float?
    let minTemp: Float?
    let weatherDescription: String?
    let weatherIconPath: String?
    let windSpeed: Float?
    let rainVolume: Float?
    var date: Date?
    var imagePath: String? {
        return weatherIconPath.map({ "http://openweathermap.org/img/w/" + $0 + ".png"})
    }
    
    
    init?(result: Any?) {
        guard let resultDict = result as? [String : Any],
            let mainDict = resultDict["main"] as? [String : Any],
            let temperature = mainDict["temp"] as? Float
            else {
                return nil
        }
        
        self.city = resultDict["name"] as? String
        let weatherDict = (resultDict["weather"] as? [[String : Any]])?.first
        self.weatherDescription = weatherDict?["description"] as? String
        
        let date = resultDict["dt_txt"] as? String
        self.date = date?.toDate()
        
        let windDict = resultDict["wind"] as? [String: Any]
        self.windSpeed = windDict?["speed"] as? Float

        self.rainVolume = mainDict["humidity"] as? Float
        
        self.weatherIconPath = weatherDict?["icon"] as? String
        
        self.temperature = temperature
        self.minTemp = mainDict["temp_min"] as? Float
    }
}
