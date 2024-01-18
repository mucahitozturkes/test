//
//  LastSearch+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 16.01.2024.
//
//

import Foundation
import CoreData


extension LastSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastSearch> {
        return NSFetchRequest<LastSearch>(entityName: "LastSearch")
    }

    @NSManaged public var calori: String?
    @NSManaged public var carbon: String?
    @NSManaged public var date: Date?
    @NSManaged public var fat: String?
    @NSManaged public var idFavorite: UUID?
    @NSManaged public var isFavorited: Bool
    @NSManaged public var protein: String?
    @NSManaged public var title: String?
    @NSManaged public var info: String?

}

extension LastSearch : Identifiable {

}
