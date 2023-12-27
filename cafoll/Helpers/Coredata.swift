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
    var favorite: [Favorite]?
    var breakfast: [Breakfast]?
    var lunch: [Lunch]?
    var dinner: [Dinner]?
    var snack: [Snack]?
    var maxValueCircle: [MaxValueCircle]?

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

            self.breakfast = try context.fetch(request)
            DispatchQueue.main.async {
                self.homeViewController?.tableView.reloadData()
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
            print("fetch lunch: ", error)
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
            print("fetch dinner: ", error)
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
            print("fetch snack: ", error)
        }
    }
    //Fetch maxValueCalori
    func fetchMaxValueCircle() {
        do {
            let request = MaxValueCircle.fetchRequest()
            self.maxValueCircle = try context.fetch(request)
        } catch {
            print("fetch maxValueCircle: ", error)
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
    func updateOrAddMaxValueCircle(maxValueCalori: Float, maxValueProtein: Float, maxValueFat: Float, maxValueCarbon: Float) {
        // Check if all values are zero, and if yes, don't save the entity
        guard maxValueCalori != 0 || maxValueProtein != 0 || maxValueFat != 0 || maxValueCarbon != 0 else {
            return
        }

        // Check if MaxValueCircle already exists in the array
        if let existingMaxValueCircle = maxValueCircle?.first {
            // Update existing MaxValueCircle
            existingMaxValueCircle.maxValueCalori = maxValueCalori
            existingMaxValueCircle.maxValueProtein = maxValueProtein
            existingMaxValueCircle.maxValueFat = maxValueFat
            existingMaxValueCircle.maxValueCarbon = maxValueCarbon
        } else {
            // Create a new MaxValueCircle and add it to the array
            let newMaxValueCircle = MaxValueCircle(context: context)
            newMaxValueCircle.maxValueCalori = maxValueCalori
            newMaxValueCircle.maxValueProtein = maxValueProtein
            newMaxValueCircle.maxValueFat = maxValueFat
            newMaxValueCircle.maxValueCarbon = maxValueCarbon
            maxValueCircle?.append(newMaxValueCircle)
        }

    }




}
