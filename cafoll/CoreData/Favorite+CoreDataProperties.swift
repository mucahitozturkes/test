//
//  Favorite+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 23.11.2023.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var title: String?

}

extension Favorite : Identifiable {

}
