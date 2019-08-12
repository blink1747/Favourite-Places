//
//  Pin+CoreDataProperties.swift
//  Favourite Places
//
//  Created by IMCS on 8/12/19.
//  Copyright © 2019 IMCS. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
