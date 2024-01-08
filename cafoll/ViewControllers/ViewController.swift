//
//  ViewController.swift
//  cafoll
//
//  Created by Mücahit Öztürk on 22.11.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    var ui: Ui!
    var helper: Helper!
    var coredata: Coredata!
    var homeViewController: HomeViewController!
    var selectedCellFoodName: String?
    var searchResults: [String: [String: Int]] = [:]
    
   
    // Bar Labels
    @IBOutlet weak var titleLabelTextfield: UITextField!
    @IBOutlet weak var caloriLabel: UITextField!
    @IBOutlet weak var fatLabel: UITextField!
    @IBOutlet weak var carbonLabel: UITextField!
    @IBOutlet weak var proteinLabel: UITextField!
    // Bars
    @IBOutlet weak var caloriBar: UIProgressView!
    @IBOutlet weak var fatBar: UIProgressView!
    @IBOutlet weak var carbonBar: UIProgressView!
    @IBOutlet weak var proteinBar: UIProgressView!
    //Views
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var gestureView: UIView!
    @IBOutlet var popupView: UIView!
    //Tools
 
    @IBOutlet weak var searchBar: UISearchBar!
    //tableView
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        startUpSetup()
    }
    
    //Start up!
    func startUpSetup() {
        
        //print(helper?.filePath ?? "Not Found")
        ui = Ui()
        helper = Helper()
        
        homeViewController = HomeViewController()
        ui.applyShadow(to: mainView, offset: CGSize(width: 0, height: 6), radius: 12)
        coredata = Coredata(viewController: self)
        searchBar.delegate = self
  
        //table View Load
        tableView.reloadData()
    }
  
    func saveFoodToCoreData(title: String, nutrientValues: [String: Int], mealEntityName: String) {
        let indexOfHomeViewController = 0

        guard let tabBarController = self.tabBarController,
            let homeViewController = tabBarController.viewControllers?[indexOfHomeViewController] as? HomeViewController else {
            print("Hata: Tab barından HomeViewController'a erişilemiyor.")
            return
        }

        let datePickerDate = homeViewController.datePicker.date
        let newFood = NSEntityDescription.insertNewObject(forEntityName: mealEntityName, into: coredata!.context)

        newFood.setValue(title, forKey: "title")
        newFood.setValue("\(nutrientValues["protein"] ?? 0)", forKey: "protein")
        newFood.setValue("\(nutrientValues["carbs"] ?? 0)", forKey: "carbon")
        newFood.setValue("\(nutrientValues["fat"] ?? 0)", forKey: "fat")
        newFood.setValue("\(nutrientValues["calories"] ?? 0)", forKey: "calori")
        newFood.setValue(datePickerDate, forKey: "date")

        coredata.saveData()
    }

}
//MARK: - Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        let foodTitle = Array(searchResults.keys)[indexPath.row]
            cell.foodTitleLabelUI?.text = foodTitle
//        if let nutrientValues = searchResults[foodTitle] {
//            cell.Ptext.text = "\(nutrientValues["protein"] ?? 0)"
//            cell.CarText.text = "\(nutrientValues["carbs"] ?? 0)"
//            cell.FText.text = "\(nutrientValues["fat"] ?? 0)"
//            cell.CText.text = "\(nutrientValues["calories"] ?? 0)"
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Food Options", message: "Select an option", preferredStyle: .actionSheet)
        let indexOfHomeViewController = 0
        guard let tabBarController = self.tabBarController,
            let homeViewController = tabBarController.viewControllers?[indexOfHomeViewController] as? HomeViewController else {
            print("Hata: Tab barından HomeViewController'a erişilemiyor.")
            return
        }
        
            let breakfastOption = UIAlertAction(title: "Breakfast", style: .default) { [weak self] _ in
                self?.searchBar.resignFirstResponder() // Klavyeyi kapat
                // Get the selected index path
                 guard let indexPath = tableView.indexPathForSelectedRow else {
                     print("Selected index path is nil.")
                     return
                 }

                 // Get the selected cell
                 guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
                     print("Cell at selected index path is not of type YourCellType.")
                     return
                 }

                 let alertBreakfast = UIAlertController(title: cell.foodTitleLabelUI.text, message: "How much gram you eat?", preferredStyle: .alert)

                 alertBreakfast.addTextField { textField in
                     textField.placeholder = "Gram"
                     textField.keyboardType = .numberPad
                 }

                 let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                     // Handle cancel action if needed
                 }

                let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    // Get grams from UITextField
                    guard let gramText = alertBreakfast.textFields?.first?.text,
                          let grams = Int(gramText) else {
                        return
                    }
                    selectedCellFoodName = Array(searchResults.keys)[indexPath.row]
                       print("Selected Cell Food Name: \(selectedCellFoodName ?? "nil")")
                    // Check if selectedCellFoodName is not nil
                    if let selectedCellFoodName = self.selectedCellFoodName,
                       var nutrientValues = self.searchResults[selectedCellFoodName] {
                        nutrientValues["protein"] = (nutrientValues["protein"] ?? 0) * grams
                        nutrientValues["carbs"] = (nutrientValues["carbs"] ?? 0) * grams
                        nutrientValues["fat"] = (nutrientValues["fat"] ?? 0) * grams
                        nutrientValues["calories"] = (nutrientValues["calories"] ?? 0) * grams

                        // Print updated nutritional values
                        print("Updated Nutrient Values: \(nutrientValues)")

                        // Create a new Breakfast entity in Core Data
                        self.saveFoodToCoreData(title: selectedCellFoodName, nutrientValues: nutrientValues, mealEntityName: "Breakfast")
                        print("saveFoodToCoreData called successfully")
                    } else {
                        // Handle the case when selectedCellFoodName is nil
                        print("selectedCellFoodName is nil")
                    }

                    searchBar.text = "" // Search bar'ın içeriğini temizle
                    searchBar.resignFirstResponder() // Klavyeyi kapat
                    searchResults = [:] // Search sonuçlarını temizle
                    tableView.reloadData()
                  
                    homeViewController.badgeCount[0] += 1

          
                }

                 alertBreakfast.addAction(cancelAction)
                 alertBreakfast.addAction(addAction)

                print("Presenting alertBreakfast")
                self?.present(alertBreakfast, animated: true, completion: nil)
                print("Alert presented")

            }
        
            let lunchOption = UIAlertAction(title: "Lunch", style: .default) { [weak self] _ in
                self?.searchBar.resignFirstResponder() // Klavyeyi kapat
                // Get the selected index path
                 guard let indexPath = tableView.indexPathForSelectedRow else {
                     print("Selected index path is nil.")
                     return
                 }

                 // Get the selected cell
                 guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
                     print("Cell at selected index path is not of type YourCellType.")
                     return
                 }

                 let alertLunch = UIAlertController(title: cell.foodTitleLabelUI.text, message: "How much gram you eat?", preferredStyle: .alert)

                alertLunch.addTextField { textField in
                     textField.placeholder = "Gram"
                     textField.keyboardType = .numberPad
                 }

                 let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                     // Handle cancel action if needed
                 }

                let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    // Get grams from UITextField
                    guard let gramText = alertLunch.textFields?.first?.text,
                          let grams = Int(gramText) else {
                        return
                    }
                    selectedCellFoodName = Array(searchResults.keys)[indexPath.row]
                       print("Selected Cell Food Name: \(selectedCellFoodName ?? "nil")")
                    // Check if selectedCellFoodName is not nil
                    if let selectedCellFoodName = self.selectedCellFoodName,
                       var nutrientValues = self.searchResults[selectedCellFoodName] {
                        nutrientValues["protein"] = (nutrientValues["protein"] ?? 0) * grams
                        nutrientValues["carbs"] = (nutrientValues["carbs"] ?? 0) * grams
                        nutrientValues["fat"] = (nutrientValues["fat"] ?? 0) * grams
                        nutrientValues["calories"] = (nutrientValues["calories"] ?? 0) * grams

                        // Print updated nutritional values
                        print("Updated Nutrient Values: \(nutrientValues)")

                        // Create a new Breakfast entity in Core Data
                        self.saveFoodToCoreData(title: selectedCellFoodName, nutrientValues: nutrientValues, mealEntityName: "Lunch")
                        print("saveFoodToCoreData called successfully")
                    } else {
                        // Handle the case when selectedCellFoodName is nil
                        print("selectedCellFoodName is nil")
                    }

                    searchBar.text = "" // Search bar'ın içeriğini temizle
                    searchBar.resignFirstResponder() // Klavyeyi kapat
                    searchResults = [:] // Search sonuçlarını temizle
                    tableView.reloadData()
                    homeViewController.badgeCount[0] += 1
              
          
                }

                alertLunch.addAction(cancelAction)
                alertLunch.addAction(addAction)

                print("Presenting alertBreakfast")
                self?.present(alertLunch, animated: true, completion: nil)
                print("Alert presented")

            }
           
        let dinnerOption = UIAlertAction(title: "Dinner", style: .default) { [weak self] _ in
            self?.searchBar.resignFirstResponder() // Klavyeyi kapat
            // Get the selected index path
             guard let indexPath = tableView.indexPathForSelectedRow else {
                 print("Selected index path is nil.")
                 return
             }

             // Get the selected cell
             guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
                 print("Cell at selected index path is not of type YourCellType.")
                 return
             }

             let alertDinner = UIAlertController(title: cell.foodTitleLabelUI.text, message: "How much gram you eat?", preferredStyle: .alert)

            alertDinner.addTextField { textField in
                 textField.placeholder = "Gram"
                 textField.keyboardType = .numberPad
             }

             let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                 // Handle cancel action if needed
             }

            let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                guard let self = self else { return }

                // Get grams from UITextField
                guard let gramText = alertDinner.textFields?.first?.text,
                      let grams = Int(gramText) else {
                    return
                }
                selectedCellFoodName = Array(searchResults.keys)[indexPath.row]
                   print("Selected Cell Food Name: \(selectedCellFoodName ?? "nil")")
                // Check if selectedCellFoodName is not nil
                if let selectedCellFoodName = self.selectedCellFoodName,
                   var nutrientValues = self.searchResults[selectedCellFoodName] {
                    nutrientValues["protein"] = (nutrientValues["protein"] ?? 0) * grams
                    nutrientValues["carbs"] = (nutrientValues["carbs"] ?? 0) * grams
                    nutrientValues["fat"] = (nutrientValues["fat"] ?? 0) * grams
                    nutrientValues["calories"] = (nutrientValues["calories"] ?? 0) * grams

                    // Print updated nutritional values
                    print("Updated Nutrient Values: \(nutrientValues)")

                    // Create a new Breakfast entity in Core Data
                    self.saveFoodToCoreData(title: selectedCellFoodName, nutrientValues: nutrientValues, mealEntityName: "Dinner")
                    print("saveFoodToCoreData called successfully")
                } else {
                    // Handle the case when selectedCellFoodName is nil
                    print("selectedCellFoodName is nil")
                }

                searchBar.text = "" // Search bar'ın içeriğini temizle
                searchBar.resignFirstResponder() // Klavyeyi kapat
                searchResults = [:] // Search sonuçlarını temizle
                tableView.reloadData()
                homeViewController.badgeCount[0] += 1
          
      
            }

            alertDinner.addAction(cancelAction)
            alertDinner.addAction(addAction)

            print("Presenting alertBreakfast")
            self?.present(alertDinner, animated: true, completion: nil)
            print("Alert presented")

        }
        
        let snackOption = UIAlertAction(title: "Snack", style: .default) { [weak self] _ in
            self?.searchBar.resignFirstResponder() // Klavyeyi kapat
            // Get the selected index path
             guard let indexPath = tableView.indexPathForSelectedRow else {
                 print("Selected index path is nil.")
                 return
             }

             // Get the selected cell
             guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
                 print("Cell at selected index path is not of type YourCellType.")
                 return
             }

             let alertSnack = UIAlertController(title: cell.foodTitleLabelUI.text, message: "How much gram you eat?", preferredStyle: .alert)

            alertSnack.addTextField { textField in
                 textField.placeholder = "Gram"
                 textField.keyboardType = .numberPad
             }

             let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                 // Handle cancel action if needed
             }

            let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                guard let self = self else { return }

                // Get grams from UITextField
                guard let gramText = alertSnack.textFields?.first?.text,
                      let grams = Int(gramText) else {
                    return
                }
                selectedCellFoodName = Array(searchResults.keys)[indexPath.row]
                   print("Selected Cell Food Name: \(selectedCellFoodName ?? "nil")")
                // Check if selectedCellFoodName is not nil
                if let selectedCellFoodName = self.selectedCellFoodName,
                   var nutrientValues = self.searchResults[selectedCellFoodName] {
                    nutrientValues["protein"] = (nutrientValues["protein"] ?? 0) * grams
                    nutrientValues["carbs"] = (nutrientValues["carbs"] ?? 0) * grams
                    nutrientValues["fat"] = (nutrientValues["fat"] ?? 0) * grams
                    nutrientValues["calories"] = (nutrientValues["calories"] ?? 0) * grams

                    // Print updated nutritional values
                    print("Updated Nutrient Values: \(nutrientValues)")

                    // Create a new Breakfast entity in Core Data
                    self.saveFoodToCoreData(title: selectedCellFoodName, nutrientValues: nutrientValues, mealEntityName: "Snack")
                    print("saveFoodToCoreData called successfully")
                } else {
                    // Handle the case when selectedCellFoodName is nil
                    print("selectedCellFoodName is nil")
                }

                searchBar.text = "" // Search bar'ın içeriğini temizle
                searchBar.resignFirstResponder() // Klavyeyi kapat
                searchResults = [:] // Search sonuçlarını temizle
                tableView.reloadData()
                homeViewController.badgeCount[0] += 1
          
      
            }

            alertSnack.addAction(cancelAction)
            alertSnack.addAction(addAction)

            print("Presenting alertBreakfast")
            self?.present(alertSnack, animated: true, completion: nil)
            print("Alert presented")

        }
            // Add actions to the alert
            alert.addAction(breakfastOption)
            alert.addAction(lunchOption)
            alert.addAction(dinnerOption)
            alert.addAction(snackOption)
          
            
            // You can set the text color of the "Edit" option in the first alert here
            breakfastOption.setValue(UIColor.options, forKey: "titleTextColor")
            lunchOption.setValue(UIColor.options, forKey: "titleTextColor")
            dinnerOption.setValue(UIColor.options, forKey: "titleTextColor")
            snackOption.setValue(UIColor.options, forKey: "titleTextColor")
            
            
            // Cancel Button
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                // Handle cancel action if needed
            }
            cancelButton.setValue(UIColor.red, forKey: "titleTextColor") // Set text color to red
            alert.addAction(cancelButton)
            
        // Present the alert
        present(alert, animated: true, completion: nil)
           
        
            
        }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    }

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            // Update searchResults based on the search text
            searchResults = foodDictionary.filter { $0.key.lowercased().contains(searchText.lowercased()) }
        } else {
            // If the search bar is empty, show an empty result
            searchResults = [:]
        }

        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // Bu fonksiyon, Cancel butonuna tıklandığında çağrılır
            searchBar.text = "" // Search bar'ın içeriğini temizle
            searchBar.resignFirstResponder() // Klavyeyi kapat
            searchResults = [:] // Search sonuçlarını temizle
            tableView.reloadData()
        }
}
