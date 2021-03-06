//
//  Trolley.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit

class Trolley: NSObject {
    
    let ID: Int
    @objc dynamic var coordinate: CLLocationCoordinate2D
    let name: String?
    let number: Int?
    let iconColor: String

    init(identifier: Int,
         coordinate: Coordinate,
         name: String?,
         number: Int?,
         iconColor: String) {
        self.name = name
        self.ID = identifier
        self.coordinate = coordinate.coordinate
        self.number = number
        self.iconColor = iconColor
    }

    convenience init(trolley: Trolley, location: CLLocation) {
        self.init(identifier: trolley.ID,
                  coordinate: Coordinate(location: location),
                  name: trolley.name,
                  number: trolley.number,
                  iconColor: trolley.iconColor)
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Trolley , object.ID == self.ID { return true }
        return false
    }
}

extension Trolley {

    var tintColor: UIColor {
        return UIColor(hex: iconColor)
    }

    var displayNameShort: String {

        let fallbackName = String(number ?? 0)

        guard let name = name else {
            return fallbackName
        }

        let comps = name.split(separator: " ")
        guard comps.count > 1 else {
            return fallbackName
        }

        return String(comps[1])
    }

    var displayNameLong: String {
        return "Trolley " + displayNameShort
    }
}

extension Trolley: MKAnnotation {

    var title: String? {
        return name
    }
    
    @objc(subtitle) var subtitle: String? {
        return ""
    }
}

struct _APIRunningTrolley: Codable {
    let ID: Int
    let Lat: Double
    let Lon: Double
}

struct _APITrolley: Codable {
    let CurrentLat: Double
    let CurrentLon: Double
    let ID: Int
    let TrolleyName: String
    let Number: Int
    let IconColorRGB: String

    var trolley: Trolley {
        let c = Coordinate(latitude: CurrentLat,
                           longitude: CurrentLon)
        return Trolley(identifier: ID,
                       coordinate: c,
                       name: TrolleyName,
                       number: Number,
                       iconColor: IconColorRGB)
    }
}
