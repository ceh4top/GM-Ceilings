//
//  Measurement+CoreDataClass.swift
//  GM Ceilings
//
//  Created by GM on 25.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
import CoreData

@objc(Measurement)
public class Measurement: NSManagedObject {
    convenience init() {
        let entity = NSEntityDescription.entity(forEntityName: "Measurement", in: CoreDataManager.instance.managedObjectContext)
        self.init(entity: entity!, insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
