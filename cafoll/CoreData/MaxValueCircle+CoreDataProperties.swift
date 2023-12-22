//
//  MaxValueCircle+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 21.12.2023.
//
//

import Foundation
import CoreData


extension MaxValueCircle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MaxValueCircle> {
        return NSFetchRequest<MaxValueCircle>(entityName: "MaxValueCircle")
    }

    @NSManaged public var maxValueCalori: Float
    @NSManaged public var maxValueProtein: Float
    @NSManaged public var maxValueFat: Float
    @NSManaged public var maxValueCarbon: Float

}

extension MaxValueCircle : Identifiable {

}
