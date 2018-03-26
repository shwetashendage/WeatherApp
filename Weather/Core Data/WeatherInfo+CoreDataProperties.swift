//
//  WeatherInfo+CoreDataProperties.swift
//  Weather
//
//  Created by Encoding on 26/03/18.
//  Copyright © 2018 Shweta. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherInfo> {
        return NSFetchRequest<WeatherInfo>(entityName: "WeatherInfo")
    }

    @NSManaged public var city: String?
    @NSManaged public var id: Int64
    @NSManaged public var main: String?
    @NSManaged public var summary: String?
    @NSManaged public var temp_max: Int64
    @NSManaged public var temp_min: Int64
    @NSManaged public var temperature: Int64
    @NSManaged public var humidity: Int64

}
