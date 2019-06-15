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
    let temperature: CGFloat?
    let minTemp: CGFloat?
    let weatherDescription: String?
    let weatherIconPath: String?
    let windSpeed: CGFloat?
    let rainVolume: CGFloat?
    var date: Date?
    var imagePath: String? {
        return weatherIconPath.map({ "http://openweathermap.org/img/w/" + $0 + ".png"})
    }
    
    
    init?(result: Any?) {
        guard let resultDict = result as? [String : Any],
            let mainDict = resultDict["main"] as? [String : Any]
            else {
                return nil
        }
        
        self.city = resultDict["name"] as? String
        let weatherDict = (resultDict["weather"] as? [[String : Any]])?.first
        self.weatherDescription = weatherDict?["description"] as? String
        
        let date = resultDict["dt_txt"] as? String
        self.date = date?.toDate()
        
        let windDict = resultDict["wind"] as? [String: Any]
        self.windSpeed = windDict?["speed"] as? CGFloat

        self.rainVolume = mainDict["humidity"] as? CGFloat
        
        self.weatherIconPath = weatherDict?["icon"] as? String
        
        self.minTemp = mainDict["temp_min"] as? CGFloat

        temperature = mainDict["temp"] as? CGFloat
    }
}
