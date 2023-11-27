//
//  Foods+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 27.11.2023.
//
//

import Foundation
import CoreData


extension Foods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Foods> {
        return NSFetchRequest<Foods>(entityName: "Foods")
    }

    @NSManaged public var title: String?
    @NSManaged public var calori: String?
    @NSManaged public var fat: String?
    @NSManaged public var carbon: String?
    @NSManaged public var protein: String?

}

extension Foods : Identifiable {

}
