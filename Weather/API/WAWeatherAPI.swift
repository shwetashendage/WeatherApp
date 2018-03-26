//
//  WAWeatherAPI.swift
//  Weather
//
//  Created by Shrikant on 25/03/18.
//  Copyright © 2018 Shweta. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum Result <T>{
    case Success(T)
    case Error(String)
}
class WAWeatherAPI{

private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/group"
private let openWeatherMapAPIKey = "248aa305015409805672fd38971b31fd"
private let openWeatherCityIds = "4163971,2147714,2174003"

    func getWeather(completion: @escaping (Result<[WAWeatherResponse]>) -> Void) {
        
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?id=\(openWeatherCityIds)&units=metric&appid=\(openWeatherMapAPIKey)")!
        Alamofire.request(weatherRequestURL).responseArray(keyPath:"list") { (response: DataResponse<[WAWeatherResponse]>) in
            
            
            let forecastArray = response.result.value
            
            if let forecastArray = forecastArray {
            
                DispatchQueue.main.async {
                    return completion(.Success(forecastArray))
                }
            }else{
                
                return completion(.Error("Could not retrieve data."))
            }
        }
        
    }
}
