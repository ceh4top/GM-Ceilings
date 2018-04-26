//
//  Measurement+CoreDataProperties.swift
//  GM Ceilings
//
//  Created by GM on 26.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
import CoreData


extension Measurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Measurement> {
        return NSFetchRequest<Measurement>(entityName: "Measurement");
    }

    @NSManaged public var address: String?
    @NSManaged public var dateTime: String?
    @NSManaged public var projectId: Int32
    @NSManaged public var projectSum: String?
    @NSManaged public var status: String?

}
