//
//  Helper.swift
//  cafoll
//
//  Created by mücahit öztürk on 22.11.2023.
//

import UIKit
import CoreData

class Coredata {
    var viewController: ViewController!
    var homeViewController: HomeViewController!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var foods: [Foods]?
    var lastSearch: [LastSearch]?
    var breakfast: [Breakfast]?
    var lunch: [Lunch]?
    var dinner: [Dinner]?
    var snack: [Snack]?

    init(viewController: ViewController) {
           self.viewController = viewController
    
       }

    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
    
    }
    
    //Fetch Foods
    func fetchFoods() {
        do {
            let request = Foods.fetchRequest()
            self.foods = try context.fetch(request)
            print("succesed: fetchFoods")
        } catch {
            print("fetch fetchFoods: ", error)
        }
    }
    //Fetch Favorite
    func fetchLastSearch() {
        do {
            let request = LastSearch.fetchRequest()
            self.lastSearch = try context.fetch(request)
            
            // Sonuçları tersine çevir
            self.lastSearch = self.lastSearch?.reversed()

            print("success: fetchLastSearch")
        } catch {
            print("fetch LastSearch: ", error)
        }
    }
    //Fetch Breakfast
    func fetchBreakfast(forDate date: Date) {
        do {
            // Create a date range for the selected day
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!

            // Use a predicate to filter by date
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startOfDay as NSDate, endOfDay as NSDate)

            let request = Breakfast.fetchRequest()
            request.predicate = predicate
            // Use 'context' directly without optional binding
            self.breakfast = try context.fetch(request)
            fetchMeals(forDate: date, entityName: "Breakfast", array: &breakfast)
            DispatchQueue.main.async {
                self.homeViewController?.tableView.reloadData()
                }
            print("succesed: fetchBreakfast")
            } catch {
                print("fetch Foods: ", error)
            }
        }
    //Fetch Lunch
    func fetchLunch(forDate date: Date) {
        do {
            // Create a date range for the selected day
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!

            // Use a predicate to filter by date
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startOfDay as NSDate, endOfDay as NSDate)
            
            let request = Lunch.fetchRequest()
            request.predicate = predicate

            self.lunch = try context.fetch(request)
            fetchMeals(forDate: date, entityName: "Lunch", array: &lunch)
            DispatchQueue.main.async {
                self.homeViewController?.tableView.reloadData()
            }
            print("succesed: fetchLunch")
        } catch {
            print("fetch Foods: ", error)
        }
    }
    //Fetch Dinner
    func fetchDinner(forDate date: Date) {
        do {
            // Create a date range for the selected day
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!

            // Use a predicate to filter by date
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startOfDay as NSDate, endOfDay as NSDate)
            
            let request = Dinner.fetchRequest()
            request.predicate = predicate

            self.dinner = try context.fetch(request)
            fetchMeals(forDate: date, entityName: "Dinner", array: &dinner)
            DispatchQueue.main.async {
                self.homeViewController?.tableView.reloadData()
            }
            print("succesed: fetchDinner")
        } catch {
            print("fetch Foods: ", error)
        }
    }
    //Fetch Snack
    func fetchSnack(forDate date: Date) {
        do {
            // Create a date range for the selected day
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!

            // Use a predicate to filter by date
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startOfDay as NSDate, endOfDay as NSDate)
            
            let request = Snack.fetchRequest()
            request.predicate = predicate

            self.snack = try context.fetch(request)
            fetchMeals(forDate: date, entityName: "Snack", array: &snack)
            DispatchQueue.main.async {
                self.homeViewController?.tableView.reloadData()
            }
            print("succesed: fetchSnack")
        } catch {
            print("fetch Foods: ", error)
        }
    }
    //Save context
    func saveData() {
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Error saving data: \(error), \(error.localizedDescription)")
        }
    }
    //reverse list items
    func fetchMeals<T: NSManagedObject>(forDate date: Date, entityName: String, array: inout [T]?) {
        do {
            // Create a date range for the selected day
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!

            // Use a predicate to filter by date
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startOfDay as NSDate, endOfDay as NSDate)

            let request = NSFetchRequest<T>(entityName: entityName)
            request.predicate = predicate

            // Use 'context' directly without optional binding
            array = try context.fetch(request)
            array?.reverse()

            DispatchQueue.main.async {
                self.homeViewController?.tableView.reloadData()
            }
        } catch {
            print("fetch Foods: ", error)
        }
    }
}
