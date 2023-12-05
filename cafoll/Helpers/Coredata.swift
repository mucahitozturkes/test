//
//  Helper.swift
//  cafoll
//
//  Created by mücahit öztürk on 22.11.2023.
//

import UIKit
import CoreData

class Coredata: UIViewController{
    var viewController: ViewController!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var foods: [Foods]?
    var favorite: [Favorite]?
    var breakfast: [Breakfast]?
    var lunch: [Lunch]?
    var dinner: [Dinner]?
    var snack: [Snack]?

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
    //Fetch Breakfast
    func fetchBreakfast() {
        do {
            let request = Breakfast.fetchRequest()
            self.breakfast = try context.fetch(request)
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
        } catch {
            print("fetch Foods: ", error)
        }
    }
    //Fetch Lunch
    func fetchLunch() {
        do {
            let request = Lunch.fetchRequest()
            self.lunch = try context.fetch(request)
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
        } catch {
            print("fetch Foods: ", error)
        }
    }
    //Fetch Dinner
    func fetchDinner() {
        do {
            let request = Dinner.fetchRequest()
            self.dinner = try context.fetch(request)
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
        } catch {
            print("fetch Foods: ", error)
        }
    }
    //Fetch Snack
    func fetchSnack() {
        do {
            let request = Snack.fetchRequest()
            self.snack = try context.fetch(request)
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
        } catch {
            print("fetch Foods: ", error)
        }
    }
    //Save context
    func saveData() {
        do {
            try self.context.save()
        } catch {
            print("Save context: ", error)
        }
    }
   

}
