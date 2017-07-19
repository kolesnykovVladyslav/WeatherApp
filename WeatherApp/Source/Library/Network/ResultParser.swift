//
//  ResultParser.swift
//  WeatherAppLecture
//
//  Created by Daria on 7/3/17.
//  Copyright © 2017 Daria. All rights reserved.
//

import Foundation

protocol ResultParser {

    func parseResult(_ result: Any?) -> Any?
    
}

extension ResultParser {

    func parseResult(_ result: Any?) -> Any? {
        return result
    }
    
}
