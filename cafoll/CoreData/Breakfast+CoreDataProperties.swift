//
//  Breakfast+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 4.12.2023.
//
//

import Foundation
import CoreData


extension Breakfast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breakfast> {
        return NSFetchRequest<Breakfast>(entityName: "Breakfast")
    }

    @NSManaged public var calori: String?
    @NSManaged public var fat: String?
    @NSManaged public var carbon: String?
    @NSManaged public var protein: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var isRight: Bool
    @NSManaged public var title: String?

}

extension Breakfast : Identifiable {

}
