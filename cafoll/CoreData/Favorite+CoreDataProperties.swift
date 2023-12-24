//
//  Favorite+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 24.12.2023.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var calori: String?
    @NSManaged public var carbon: String?
    @NSManaged public var fat: String?
    @NSManaged public var idFavorite: UUID?
    @NSManaged public var isFavorited: Bool
    @NSManaged public var protein: String?
    @NSManaged public var title: String?

}

extension Favorite : Identifiable {

}
