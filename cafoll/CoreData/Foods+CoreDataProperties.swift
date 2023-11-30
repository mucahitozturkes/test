//
//  Foods+CoreDataProperties.swift
//  cafoll
//
//  Created by mücahit öztürk on 30.11.2023.
//
//

import Foundation
import CoreData


extension Foods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Foods> {
        return NSFetchRequest<Foods>(entityName: "Foods")
    }
    @NSManaged public var isFavorited: Bool
    @NSManaged public var calori: String?
    @NSManaged public var carbon: String?
    @NSManaged public var fat: String?
    @NSManaged public var protein: String?
    @NSManaged public var title: String?
    @NSManaged public var idFood: UUID?

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
        favorite.idFavorite = self.idFood // Assuming you have an id in Favorite corresponding to the idFood in Foods
        return favorite
    }
}
