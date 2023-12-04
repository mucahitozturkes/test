//
//  Lunch+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 4.12.2023.
//
//

import Foundation
import CoreData


extension Lunch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lunch> {
        return NSFetchRequest<Lunch>(entityName: "Lunch")
    }

    @NSManaged public var title: String?
    @NSManaged public var calori: String?
    @NSManaged public var carbon: String?
    @NSManaged public var date: Date?
    @NSManaged public var fat: String?
    @NSManaged public var isRight: Bool
    @NSManaged public var protein: String?
    @NSManaged public var uuid: UUID?

}

extension Lunch : Identifiable {

}
