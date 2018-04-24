//
//  Geoposition.swift
//  GM Ceilings
//
//  Created by GM on 20.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
import CoreLocation

public class Geoposition {
    public static var position : CLLocationCoordinate2D? = nil
    public static var latitude : Double? = nil
    public static var longitude : Double? = nil
    public static var isEmpty : Bool = true
    
    private static var locationManager : CLLocationManager! = CLLocationManager()
    
    public static func update() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 200
        self.locationManager.requestWhenInUseAuthorization()
        
        self.position = locationManager.location?.coordinate
        self.latitude = position?.latitude
        self.longitude = position?.longitude
        self.isEmpty = self.position == nil
    }
}
