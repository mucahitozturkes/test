//
//  Favori+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 23.11.2023.
//
//

import Foundation
import CoreData


extension Favori {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favori> {
        return NSFetchRequest<Favori>(entityName: "Favori")
    }

    @NSManaged public var title: String?

}

extension Favori : Identifiable {

}
