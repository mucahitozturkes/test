//
//  Foods+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 24.12.2023.
//
//

import Foundation
import CoreData


extension Foods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Foods> {
        return NSFetchRequest<Foods>(entityName: "Foods")
    }

    @NSManaged public var calori: String?
    @NSManaged public var carbon: String?
    @NSManaged public var fat: String?
    @NSManaged public var idFood: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var protein: String?
    @NSManaged public var title: String?

}

extension Foods : Identifiable {

}
extension Foods {
    func asFavorite() -> Favorite {
        let favorite = Favorite(context: managedObjectContext!) // Assuming you are using a managedObjectContext
        favorite.calori = self.calori
        favorite.carbon = self.carbon
        favorite.fat = self.fat
        favorite.protein = self.protein
        favorite.title = self.title
        favorite.isFavorited = self.isFavorite
        favorite.idFavorite = self.idFood // Assuming you have an id in Favorite corresponding to the idFood in Foods
        return favorite
    }
}
