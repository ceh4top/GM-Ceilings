//
//  EMeasurement+CoreDataClass.swift
//  GM Ceilings
//
//  Created by GM on 17.04.18.
//  Copyright © 2018 GM. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(EMeasurement)
public class EMeasurement: NSManagedObject {
    convenience init() {
        let entity = NSEntityDescription.entity(forEntityName: "EMeasurement", in: CoreDataManager.instance.managedObjectContext)
        self.init(entity: entity!, insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
