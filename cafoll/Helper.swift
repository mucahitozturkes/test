//
//  Helper.swift
//  cafoll
//
//  Created by mücahit öztürk on 22.11.2023.
//

import UIKit
import CoreData

class Helper: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    var viewController: ViewController!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var foods: [Foods]?
    var favorite: [Favorite]?
    
    //Save context
    func saveData() {
        do {
            try self.context.save()
        } catch {
            print("Save context: ", error)
        }
    }
    //Fetch Foods
    func fetchFoods() {
        do {
            let request = Foods.fetchRequest()
            self.foods = try context.fetch(request)
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
        } catch {
            print("fetch Foods: ", error)
        }
    }
    //Fetch Favorite
    func fetchFavorite() {
        do {
            let request = Favorite.fetchRequest()
            self.favorite = try context.fetch(request)
        } catch {
            print("fetch Favorite: ", error)
        }
    }
    //Haptic
    func generateHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

   
}
