//
//  EMeasurement+CoreDataProperties.swift
//  GM Ceilings
//
//  Created by GM on 17.04.18.
//  Copyright © 2018 GM. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension EMeasurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EMeasurement> {
        return NSFetchRequest<EMeasurement>(entityName: "EMeasurement");
    }

    @NSManaged public var address: String?
    @NSManaged public var apartmentNumber: String?
    @NSManaged public var dateTimeMeasurement: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var user_id: Int32
    @NSManaged public var user: EUser?

}
