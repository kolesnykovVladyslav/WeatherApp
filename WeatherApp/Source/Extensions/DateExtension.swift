//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Vlad Kolesnykov on 18.07.17.
//  Copyright © 2017 Vladyslav Kolesnykov. All rights reserved.
//

import Foundation

extension Date {
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
