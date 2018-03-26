//
//  WAWeatherResponse.swift
//  Weather
//
//  Created by Shrikant on 25/03/18.
//  Copyright © 2018 Shweta. All rights reserved.
//

import Foundation
import ObjectMapper

class WAWeatherResponse: Mappable {
    var city: String?
    var temperature: Int?
    var id: Int?
    var weather: [Weather]?
    var humidity: Int?
    var temp_min: Int?
    var temp_max: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        city <- map["name"]
        temperature <- map["main.temp"]
        humidity <- map["main.humidity"]
        temp_min <- map["main.temp_min"]
        temp_max <- map["main.temp_max"]
        id <- map["id"]
        weather <- map["weather"]

    }
}
class Weather: Mappable {
    var main: String?
    var summary: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        main <- map["main"]
        summary <- map["description"]
}
}

