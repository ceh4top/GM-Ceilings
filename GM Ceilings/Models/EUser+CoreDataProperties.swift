//
//  EUser+CoreDataProperties.swift
//  GM Ceilings
//
//  Created by GM on 17.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
import CoreData


extension EUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EUser> {
        return NSFetchRequest<EUser>(entityName: "EUser");
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var work: Bool
    @NSManaged public var measurement: NSSet?

}

// MARK: Generated accessors for measurement
extension EUser {

    @objc(addMeasurementObject:)
    @NSManaged public func addToMeasurement(_ value: EMeasurement)

    @objc(removeMeasurementObject:)
    @NSManaged public func removeFromMeasurement(_ value: EMeasurement)

    @objc(addMeasurement:)
    @NSManaged public func addToMeasurement(_ values: NSSet)

    @objc(removeMeasurement:)
    @NSManaged public func removeFromMeasurement(_ values: NSSet)

}
