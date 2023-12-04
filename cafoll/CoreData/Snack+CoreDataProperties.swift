//
//  Snack+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 4.12.2023.
//
//

import Foundation
import CoreData


extension Snack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Snack> {
        return NSFetchRequest<Snack>(entityName: "Snack")
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

extension Snack : Identifiable {

}
