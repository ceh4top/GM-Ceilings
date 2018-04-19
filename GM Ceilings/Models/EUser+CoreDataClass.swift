//
//  EUser+CoreDataClass.swift
//  GM Ceilings
//
//  Created by GM on 17.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import Foundation
import CoreData

@objc(EUser)
public class EUser: NSManagedObject {
    convenience init() {
        let entity = NSEntityDescription.entity(forEntityName: "EUser", in: CoreDataManager.instance.managedObjectContext)
        self.init(entity: entity!, insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
