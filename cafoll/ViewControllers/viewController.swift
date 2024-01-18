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
    var selectedCellFoodNameManuel: String?
    var selectedCellFoodNameLast: String?
    var isSearching: Bool = false
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    //Views
    @IBOutlet weak var mainView: UIView!
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
        coredata.fetchFoods()
        coredata.fetchLastSearch()
        tableView.reloadData()
        addButton.isHidden = true
    }
    
    func saveFoodToCoreData(title: String, food: Food, mealEntityName: String, grams: Float) {
        let indexOfHomeViewController = 0
        
        guard let tabBarController = self.tabBarController,
              let homeViewController = tabBarController.viewControllers?[indexOfHomeViewController] as? HomeViewController else {
            print("Hata: Tab barından HomeViewController'a erişilemiyor.")
            return
        }
        
        let datePickerDate = homeViewController.datePicker.date
        let newFood = NSEntityDescription.insertNewObject(forEntityName: mealEntityName, into: coredata!.context)
        
        // Önce 100'e bölme işlemini gerçekleştir
        let divisor: Float = 100.0
        
        // Grams ile çarpma işlemini gerçekleştir
        let multipliedProtein = (food.protein / divisor) * grams
        let multipliedCarbs = (food.carbs / divisor) * grams
        let multipliedFat = (food.fat / divisor) * grams
        let multipliedCalories = (food.calories / divisor) * grams

        // Sonuçları kaydet
        newFood.setValue(title, forKey: "title")
        newFood.setValue(NSString(format: "%.2f", multipliedProtein), forKey: "protein")
        newFood.setValue(NSString(format: "%.2f", multipliedCarbs), forKey: "carbon")
        newFood.setValue(NSString(format: "%.2f", multipliedFat), forKey: "fat")
        newFood.setValue(NSString(format: "%.2f", multipliedCalories), forKey: "calori")
        newFood.setValue(datePickerDate, forKey: "date")
        
        coredata.saveData()
    }

    @IBAction func segmentButtonPressed(_ sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex
        
        switch currentSegmentIndex{
        case 0:
            addButton.isHidden = true
            searchBar.isHidden = false
            tableView.reloadData()
        case 1:
            addButton.isHidden = false
            searchBar.isHidden = true
            coredata.fetchFoods()
            tableView.reloadData()
        default:
            return
        }
    }
    
    @IBAction func deleteSearchAndManuel(_ sender: UIButton) {
        let currentSegmentIndex = segmentedControl.selectedSegmentIndex
        
        switch currentSegmentIndex {
        case 0:
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            // Delete all records from LastSearch
            if let lastSearch = coredata.lastSearch {
                for item in lastSearch {
                    coredata.context.delete(item)
                }
                coredata.saveData()
                coredata.fetchLastSearch()
            }
        case 1:
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            // Delete all records from Foods
            if let foods = coredata.foods {
                for item in foods {
                    coredata.context.delete(item)
                }
                coredata.saveData()
                coredata.fetchFoods()
            }
        default:
            break
        }
        
        // Reload the table view
        tableView.reloadData()
    }
    
    @IBAction func addNewFoodButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Food", message: "Just write your food", preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.placeholder = " + Food"
            textfield.textAlignment = .center
            textfield.borderStyle = .none
            
        }
        alert.addTextField { textfield in
            textfield.placeholder = " + Protein"
            textfield.keyboardType = .decimalPad
            textfield.borderStyle = .none
        }
        alert.addTextField { textfield in
            textfield.placeholder = " + Carbon"
            textfield.keyboardType = .decimalPad
            textfield.borderStyle = .none
        }
        alert.addTextField { textfield in
            textfield.placeholder = " + Fat"
            textfield.keyboardType = .decimalPad
            textfield.borderStyle = .none
        }
        alert.addTextField { textfield in
            textfield.placeholder = " + Calori"
            textfield.keyboardType = .decimalPad
            textfield.borderStyle = .none
        }
        
        // Add Button Way
        let addButton = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            // Check if all textfields are filled
            let foodTitle = alert.textFields?[0].text
            let foodProtein = alert.textFields?[1].text
            let foodCarbon = alert.textFields?[2].text
            let foodFat = alert.textFields?[3].text
            let foodCalori = alert.textFields?[4].text
            
            // Equal with Labels
            let equalInfo = Foods(context: (self?.coredata.context)!)
            equalInfo.title = foodTitle?.capitalized
            equalInfo.protein = foodProtein
            equalInfo.carbon = foodCarbon
            equalInfo.fat = foodFat
            equalInfo.calori = foodCalori
            
            
            // Save Data
            self?.coredata.saveData()
            // Fetch Data
            self?.coredata.fetchFoods()
            // Reverse the array to show the most recently added items at the top
            self?.coredata.foods?.reverse()
            // Call cell
            self?.tableView.reloadData()
        }
        
        // Cancel Button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle cancel action if needed
        }
        cancelButton.setValue(UIColor.red, forKey: "titleTextColor") // Set text color to red
        alert.addAction(cancelButton)
        
        // Initially disable the Add button
        addButton.isEnabled = false
        
        // Add observers to all textfields to enable/disable the Add button based on their content
        for textField in alert.textFields! {
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                addButton.isEnabled = alert.textFields?.allSatisfy { !$0.text!.isEmpty } ?? false
            }
        }
        
        alert.addAction(addButton)
        
        present(alert, animated: true, completion: nil)
    }
}
//MARK: - Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if isSearching {
                return searchResults.count
            } else {
                return self.coredata.lastSearch?.count ?? 0
            }
        case 1:
            coredata.fetchFoods()
            return self.coredata.foods?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else {
            return UITableViewCell()
        }

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if isSearching {
                let foodTitle = Array(searchResults.keys)[indexPath.row]
                cell.foodTitleLabelUI?.text = foodTitle

                if let selectedFood = searchResults[foodTitle] {
                    cell.infoLabel.text = selectedFood.info
                } else {
                    cell.infoLabel.text = "Info not available"
                }
                cell.lastSearchImage.isHidden = true
            } else {
                if let lastFood = coredata.lastSearch?[indexPath.row] {
                    print("Last Food Info: \(lastFood.info ?? "nil")")
                    cell.foodTitleLabelUI?.text = lastFood.title

                    if let lastFoodInfo = lastFood.info, !lastFoodInfo.isEmpty {
                        cell.infoLabel.text = lastFoodInfo
                    } else {
                        cell.infoLabel.text = "Info not available"
                    }

                    cell.lastSearchImage.isHidden = false
                } else {
                    print("lastFood is nil at indexPath \(indexPath.row)")
                    cell.foodTitleLabelUI?.text = "Title not available"
                    cell.infoLabel.text = "Info not available"
                    cell.lastSearchImage.isHidden = true
                }

            }

        case 1:
            let indexFavorite = self.coredata.foods?[indexPath.row]
            cell.foodTitleLabelUI.text = indexFavorite?.title
            // Burada favori olan gıdanın info değerine nasıl eriştiğinizi belirlemelisiniz.
            // Eğer "info" değeri varsa, aşağıdaki gibi kullanabilirsiniz:
            // cell.infoLabel.text = indexFavorite?.info ?? "Info not available"
            cell.lastSearchImage.isHidden = true
        default:
            break
        }

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
            if self?.segmentedControl.selectedSegmentIndex == 0 {
                let alertBreakfast = UIAlertController(title: cell.foodTitleLabelUI.text, message: cell.infoLabel.text, preferredStyle: .alert)
                
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
                          let grams = Float(gramText) else {
                        return
                    }
                    
                    
                    //check if list is empty?
                    let keysArray = Array(searchResults.keys)
                    
                    if keysArray.isEmpty {
                        print("Search results are empty.")
                        // Handle the case when there are no search results, e.g., show a message to the user.
                    } else {
                        if indexPath.row < keysArray.count {
                            selectedCellFoodName = keysArray[indexPath.row]
                            print("Selected Cell Food Name: \(selectedCellFoodName ?? "nil")")
                            // ... rest of your code related to selectedCellFoodName
                        } else {
                            print("Index out of range: \(indexPath.row) for keysArray with count \(keysArray.count)")
                            // Handle the case when indexPath.row is out of range.
                        }
                    }
                    
                    
                    // Check if selectedCellFoodName is not nil
                    if let selectedCellFoodName = self.selectedCellFoodName,
                       let existingLastFood = self.coredata.lastSearch?.first(where: { $0.title == selectedCellFoodName }),
                       let nutrientValues = searchResults[selectedCellFoodName] {
                        
                        // If a record with the same title exists, update its nutrient values
                        // Önce 100'e bölme işlemini gerçekleştir
                        let divisor: Float = 100.0

                        // Besin öğelerini al
                        let existingCalories = Float(existingLastFood.calori ?? "0.0") ?? 0.0
                        let existingCarbs = Float(existingLastFood.carbon ?? "0.0") ?? 0.0
                        let existingFat = Float(existingLastFood.fat ?? "0.0") ?? 0.0
                        let existingProtein = Float(existingLastFood.protein ?? "0.0") ?? 0.0

                        // Grams ile çarpma işlemini gerçekleştir
                        let multipliedExistingCalories = (existingCalories + (nutrientValues.calories / divisor)) * Float(grams)
                        let multipliedExistingCarbs = (existingCarbs + (nutrientValues.carbs / divisor)) * Float(grams)
                        let multipliedExistingFat = (existingFat + (nutrientValues.fat / divisor)) * Float(grams)
                        let multipliedExistingProtein = (existingProtein + (nutrientValues.protein / divisor)) * Float(grams)


                        // Sonuçları String olarak kaydet
                        existingLastFood.calori = String(multipliedExistingCalories)
                        existingLastFood.carbon = String(multipliedExistingCarbs)
                        existingLastFood.fat = String(multipliedExistingFat)
                        existingLastFood.protein = String(multipliedExistingProtein)


                  
                        // Print updated nutritional values
                        print("Updated Nutrient Values: \(nutrientValues)")
                        
                        // Print updated LastSearch entity
                        print("Updated LastSearch Entity: \(existingLastFood)")
                    } else {
                        // Check if selectedCellFoodName is not nil
                        if let selectedCellFoodName = self.selectedCellFoodName,
                           let nutrientValues = searchResults[selectedCellFoodName] {

                            // If a record with the same title exists, create a new LastSearch entity
                            // instead of updating the existing LastSearch entity
                            let newLastSearch = LastSearch(context: self.coredata.context)
                            newLastSearch.title = selectedCellFoodName
                            newLastSearch.calori = String(format: "%.2f", nutrientValues.calories)
                            newLastSearch.carbon = String(format: "%.2f", nutrientValues.carbs)
                            newLastSearch.fat = String(format: "%.2f", nutrientValues.fat)
                            newLastSearch.protein = String(format: "%.2f", nutrientValues.protein)
                            newLastSearch.info = nutrientValues.info

                            // Save the new LastSearch entity to Core Data
                            self.saveFoodToCoreData(title: selectedCellFoodName, food: nutrientValues, mealEntityName: "Breakfast", grams: grams)
                            
                            // Print added LastSearch entity
                            print("Added LastSearch Entity: \(newLastSearch)")
                        } else {
                            // Handle the case when selectedCellFoodName is nil
                            print("selectedCellFoodName is nil")
                        }
                    }
                    if isSearching == false {
                        let datePickerDate = homeViewController.datePicker.date
                        if let selectedFood = self.coredata.lastSearch?[indexPath.row] {
                            let selectedCellFoodNameLast = selectedFood.title
                            print("Selected Cell Food Name: \(selectedCellFoodNameLast ?? "nil")")
                            
                            // ... rest of your code related to selectedCellFoodName
                            
                            // Check if selectedCellFoodName is not nil
                            if let gramsText = alertBreakfast.textFields?.first?.text,
                               let grams = Float(gramsText) {
                                
                                // Create a new Breakfast entity in Core Data
                                let context = self.coredata.context
                                let newFood = Breakfast(context: context)
                                newFood.title = selectedCellFoodNameLast
                                // Önce 100'e bölme işlemini gerçekleştir
                                let divisor: Float = 100.0

                                // Seçili yemek için bilgileri al
                                let selectedCalories = Float(selectedFood.calori ?? "0.0") ?? 0.0
                                let selectedCarbs = Float(selectedFood.carbon ?? "0.0") ?? 0.0
                                let selectedFat = Float(selectedFood.fat ?? "0.0") ?? 0.0
                                let selectedProtein = Float(selectedFood.protein ?? "0.0") ?? 0.0

                                // Grams ile çarpma işlemini gerçekleştir
                                let multipliedCalories = selectedCalories / divisor * Float(grams)
                                let multipliedCarbs = selectedCarbs / divisor * Float(grams)
                                let multipliedFat = selectedFat / divisor * Float(grams)
                                let multipliedProtein = selectedProtein / divisor * Float(grams)

                                // Sonuçları String olarak kaydet
                                newFood.calori = String(multipliedCalories)
                                newFood.carbon = String(multipliedCarbs)
                                newFood.fat = String(multipliedFat)
                                newFood.protein = String(multipliedProtein)

                                newFood.date = datePickerDate
                                
                                // Save the new Breakfast entity to Core Data
                                self.coredata.saveData()
                                
                                // Print added Breakfast entity
                                print("Added Breakfast Entity: \(newFood)")
                                
                                // ... rest of your code
                            } else {
                                // Handle the case when some of the values are nil or conversion fails
                                print("Some values are nil or conversion fails.")
                            }
                        } else {
                            print("Selected food is nil.")
                        }
                        
                    }
                    tableView.reloadData()
                    homeViewController.badgeCount[0] += 1
                    print("Segment 0 selected")
                }
                
                alertBreakfast.addAction(cancelAction)
                alertBreakfast.addAction(addAction)
                
                self?.present(alertBreakfast, animated: true, completion: nil)
                
            }
            
            if self?.segmentedControl.selectedSegmentIndex == 1 {
                let datePickerDate = homeViewController.datePicker.date
                self?.selectedCellFoodNameManuel = self?.coredata.foods?[indexPath.row].title
                print("Selected Cell Food Name: \(self?.selectedCellFoodNameManuel ?? "nil")")
                
                if let context = self?.coredata.context {
                    let newFood = Breakfast(context: context)
                    newFood.title   = self?.coredata.foods?[indexPath.row].title
                    newFood.calori  = self?.coredata.foods?[indexPath.row].calori
                    newFood.protein = self?.coredata.foods?[indexPath.row].protein
                    newFood.fat     = self?.coredata.foods?[indexPath.row].fat
                    newFood.carbon  = self?.coredata.foods?[indexPath.row].carbon
                    newFood.date    = datePickerDate
                    
                    print("added", "\(newFood.title ?? "0")")
                } else {
                    // Handle the case when the context is nil.
                    print("Error: NSManagedObjectContext is nil.")
                }
                self?.coredata.saveData()
                print("Segment 1 selected")
                homeViewController.badgeCount[0] += 1
            }
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
            if self?.segmentedControl.selectedSegmentIndex == 0 {
                let alertLunch = UIAlertController(title: cell.foodTitleLabelUI.text, message: cell.infoLabel.text, preferredStyle: .alert)
                
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
                          let grams = Float(gramText) else {
                        return
                    }
                    
                    
                    //check if list is empty?
                    let keysArray = Array(searchResults.keys)
                    
                    if keysArray.isEmpty {
                        print("Search results are empty.")
                        // Handle the case when there are no search results, e.g., show a message to the user.
                    } else {
                        if indexPath.row < keysArray.count {
                            selectedCellFoodName = keysArray[indexPath.row]
                            print("Selected Cell Food Name: \(selectedCellFoodName ?? "nil")")
                            // ... rest of your code related to selectedCellFoodName
                        } else {
                            print("Index out of range: \(indexPath.row) for keysArray with count \(keysArray.count)")
                            // Handle the case when indexPath.row is out of range.
                        }
                    }
                    
                    
                    // Check if selectedCellFoodName is not nil
                    if let selectedCellFoodName = self.selectedCellFoodName,
                       let existingLastFood = self.coredata.lastSearch?.first(where: { $0.title == selectedCellFoodName }),
                       let nutrientValues = searchResults[selectedCellFoodName] {
                        
                        let divisor: Float = 100.0

                        // Besin öğelerini al
                        let existingCalories = Float(existingLastFood.calori ?? "0.0") ?? 0.0
                        let existingCarbs = Float(existingLastFood.carbon ?? "0.0") ?? 0.0
                        let existingFat = Float(existingLastFood.fat ?? "0.0") ?? 0.0
                        let existingProtein = Float(existingLastFood.protein ?? "0.0") ?? 0.0

                        // Grams ile çarpma işlemini gerçekleştir
                        let multipliedExistingCalories = (existingCalories + (nutrientValues.calories / divisor)) * Float(grams)
                            let multipliedExistingCarbs = (existingCarbs + (nutrientValues.carbs / divisor)) * Float(grams)
                            let multipliedExistingFat = (existingFat + (nutrientValues.fat / divisor)) * Float(grams)
                            let multipliedExistingProtein = (existingProtein + (nutrientValues.protein / divisor)) * Float(grams)

                        // Sonuçları String olarak kaydet
                        existingLastFood.calori = String(multipliedExistingCalories)
                        existingLastFood.carbon = String(multipliedExistingCarbs)
                        existingLastFood.fat = String(multipliedExistingFat)
                        existingLastFood.protein = String(multipliedExistingProtein)

                        
                        // Print updated nutritional values
                        print("Updated Nutrient Values: \(nutrientValues)")
                        
                        // Print updated LastSearch entity
                        print("Updated LastSearch Entity: \(existingLastFood)")
                    } else {
                        // Check if selectedCellFoodName is not nil
                        if let selectedCellFoodName = self.selectedCellFoodName,
                           let nutrientValues = searchResults[selectedCellFoodName] {

                            // If a record with the same title exists, create a new LastSearch entity
                            // instead of updating the existing LastSearch entity
                            let newLastSearch = LastSearch(context: self.coredata.context)
                            newLastSearch.title = selectedCellFoodName
                            newLastSearch.calori = String(format: "%.2f", nutrientValues.calories)
                            newLastSearch.carbon = String(format: "%.2f", nutrientValues.carbs)
                            newLastSearch.fat = String(format: "%.2f", nutrientValues.fat)
                            newLastSearch.protein = String(format: "%.2f", nutrientValues.protein)
                            newLastSearch.info = nutrientValues.info


                            
                            // Print updated nutritional values
                            print("Updated Nutrient Values: \(nutrientValues)")
                            
                            // Create a new Breakfast entity in Core Data
                            self.saveFoodToCoreData(title: selectedCellFoodName, food: nutrientValues, mealEntityName: "Lunch", grams: grams)
                            print("saveFoodToCoreData called successfully")
                    
                        } else {
                            // Handle the case when selectedCellFoodName is nil
                            print("selectedCellFoodName is nil")
                        }
                    }
                    if isSearching == false {
                        let datePickerDate = homeViewController.datePicker.date
                        if let selectedFood = self.coredata.lastSearch?[indexPath.row] {
                            let selectedCellFoodNameLast = selectedFood.title
                            print("Selected Cell Food Name: \(selectedCellFoodNameLast ?? "nil")")
                            
                            // ... rest of your code related to selectedCellFoodName
                            
                            // Check if selectedCellFoodName is not nil
                            if let gramsText = alertLunch.textFields?.first?.text,
                               let grams = Float(gramsText) {
                                
                                // Create a new Breakfast entity in Core Data
                                let context = self.coredata.context
                                let newFood = Lunch(context: context)
                                newFood.title = selectedCellFoodNameLast
                                let divisor: Float = 100.0

                                // Seçili yemek için bilgileri al
                                let selectedCalories = Float(selectedFood.calori ?? "0.0") ?? 0.0
                                let selectedCarbs = Float(selectedFood.carbon ?? "0.0") ?? 0.0
                                let selectedFat = Float(selectedFood.fat ?? "0.0") ?? 0.0
                                let selectedProtein = Float(selectedFood.protein ?? "0.0") ?? 0.0

                                // Grams ile çarpma işlemini gerçekleştir
                                let multipliedCalories = selectedCalories / divisor * Float(grams)
                                let multipliedCarbs = selectedCarbs / divisor * Float(grams)
                                let multipliedFat = selectedFat / divisor * Float(grams)
                                let multipliedProtein = selectedProtein / divisor * Float(grams)

                                // Sonuçları String olarak kaydet
                                newFood.calori = String(multipliedCalories)
                                newFood.carbon = String(multipliedCarbs)
                                newFood.fat = String(multipliedFat)
                                newFood.protein = String(multipliedProtein)

                                newFood.date = datePickerDate
                                
                                // Save the new Breakfast entity to Core Data
                                self.coredata.saveData()
                                
                                // Print added Breakfast entity
                                print("Added Breakfast Entity: \(newFood)")
                                
                                // ... rest of your code
                            } else {
                                // Handle the case when some of the values are nil or conversion fails
                                print("Some values are nil or conversion fails.")
                            }
                        } else {
                            print("Selected food is nil.")
                        }
                        
                    }
                    tableView.reloadData()
                    homeViewController.badgeCount[0] += 1
                    print("Segment 0 selected")
                }
                alertLunch.addAction(cancelAction)
                alertLunch.addAction(addAction)
                
                self?.present(alertLunch, animated: true, completion: nil)
            }
            
            if self?.segmentedControl.selectedSegmentIndex == 1 {
                let datePickerDate = homeViewController.datePicker.date
                self?.selectedCellFoodNameManuel = self?.coredata.foods?[indexPath.row].title
                print("Selected Cell Food Name: \(self?.selectedCellFoodNameManuel ?? "nil")")
                
                if let context = self?.coredata.context {
                    let newFood = Lunch(context: context)
                    newFood.title   = self?.coredata.foods?[indexPath.row].title
                    newFood.calori  = self?.coredata.foods?[indexPath.row].calori
                    newFood.protein = self?.coredata.foods?[indexPath.row].protein
                    newFood.fat     = self?.coredata.foods?[indexPath.row].fat
                    newFood.carbon  = self?.coredata.foods?[indexPath.row].carbon
                    newFood.date    = datePickerDate
                    
                    print("added", "\(newFood.title ?? "0")")
                } else {
                    // Handle the case when the context is nil.
                    print("Error: NSManagedObjectContext is nil.")
                }
                self?.coredata.saveData()
                print("Segment 1 selected")
                homeViewController.badgeCount[0] += 1
            }
            
            
            
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
            if self?.segmentedControl.selectedSegmentIndex == 0 {
                let alertDinner = UIAlertController(title: cell.foodTitleLabelUI.text, message: cell.infoLabel.text, preferredStyle: .alert)
                
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
                          let grams = Float(gramText) else {
                        return
                    }
                    
                    
                    //check if list is empty?
                    let keysArray = Array(searchResults.keys)
                    
                    if keysArray.isEmpty {
                        print("Search results are empty.")
                        // Handle the case when there are no search results, e.g., show a message to the user.
                    } else {
                        if indexPath.row < keysArray.count {
                            selectedCellFoodName = keysArray[indexPath.row]
                            print("Selected Cell Food Name: \(selectedCellFoodName ?? "nil")")
                            // ... rest of your code related to selectedCellFoodName
                        } else {
                            print("Index out of range: \(indexPath.row) for keysArray with count \(keysArray.count)")
                            // Handle the case when indexPath.row is out of range.
                        }
                    }
                    
                    
                    // Check if selectedCellFoodName is not nil
                    if let selectedCellFoodName = self.selectedCellFoodName,
                       let existingLastFood = self.coredata.lastSearch?.first(where: { $0.title == selectedCellFoodName }),
                       let nutrientValues = searchResults[selectedCellFoodName] {
                        
                        let divisor: Float = 100.0

                        // Besin öğelerini al
                        let existingCalories = Float(existingLastFood.calori ?? "0.0") ?? 0.0
                        let existingCarbs = Float(existingLastFood.carbon ?? "0.0") ?? 0.0
                        let existingFat = Float(existingLastFood.fat ?? "0.0") ?? 0.0
                        let existingProtein = Float(existingLastFood.protein ?? "0.0") ?? 0.0

                        // Grams ile çarpma işlemini gerçekleştir
                        let multipliedExistingCalories = (existingCalories + (nutrientValues.calories / divisor)) * Float(grams)
                            let multipliedExistingCarbs = (existingCarbs + (nutrientValues.carbs / divisor)) * Float(grams)
                            let multipliedExistingFat = (existingFat + (nutrientValues.fat / divisor)) * Float(grams)
                            let multipliedExistingProtein = (existingProtein + (nutrientValues.protein / divisor)) * Float(grams)


                        // Sonuçları String olarak kaydet
                        existingLastFood.calori = String(multipliedExistingCalories)
                        existingLastFood.carbon = String(multipliedExistingCarbs)
                        existingLastFood.fat = String(multipliedExistingFat)
                        existingLastFood.protein = String(multipliedExistingProtein)

                        
                        // Print updated nutritional values
                        print("Updated Nutrient Values: \(nutrientValues)")
                        
                        // Print updated LastSearch entity
                        print("Updated LastSearch Entity: \(existingLastFood)")
                    } else {
                        // Check if selectedCellFoodName is not nil
                        if let selectedCellFoodName = self.selectedCellFoodName,
                           let nutrientValues = searchResults[selectedCellFoodName] {

                            // If a record with the same title exists, create a new LastSearch entity
                            // instead of updating the existing LastSearch entity
                            let newLastSearch = LastSearch(context: self.coredata.context)
                            newLastSearch.title = selectedCellFoodName
                            newLastSearch.calori = String(format: "%.2f", nutrientValues.calories)
                            newLastSearch.carbon = String(format: "%.2f", nutrientValues.carbs)
                            newLastSearch.fat = String(format: "%.2f", nutrientValues.fat)
                            newLastSearch.protein = String(format: "%.2f", nutrientValues.protein)
                            newLastSearch.info = nutrientValues.info



                            print("Updated Nutrient Values: \(nutrientValues)")
                            
                            // Create a new Breakfast entity in Core Data
                            self.saveFoodToCoreData(title: selectedCellFoodName, food: nutrientValues, mealEntityName: "Dinner", grams: grams)
                            print("saveFoodToCoreData called successfully")
                        
                        } else {
                            // Handle the case when selectedCellFoodName is nil
                            print("selectedCellFoodName is nil")
                        }
                    }
                    if isSearching == false {
                        let datePickerDate = homeViewController.datePicker.date
                        if let selectedFood = self.coredata.lastSearch?[indexPath.row] {
                            let selectedCellFoodNameLast = selectedFood.title
                            print("Selected Cell Food Name: \(selectedCellFoodNameLast ?? "nil")")
                            
                            // ... rest of your code related to selectedCellFoodName
                            
                            // Check if selectedCellFoodName is not nil
                            if let gramsText = alertDinner.textFields?.first?.text,
                               let grams = Float(gramsText) {
                                
                                // Create a new Breakfast entity in Core Data
                                let context = self.coredata.context
                                let newFood = Dinner(context: context)
                                newFood.title = selectedCellFoodNameLast
                                let divisor: Float = 100.0

                                // Seçili yemek için bilgileri al
                                let selectedCalories = Float(selectedFood.calori ?? "0.0") ?? 0.0
                                let selectedCarbs = Float(selectedFood.carbon ?? "0.0") ?? 0.0
                                let selectedFat = Float(selectedFood.fat ?? "0.0") ?? 0.0
                                let selectedProtein = Float(selectedFood.protein ?? "0.0") ?? 0.0

                                // Grams ile çarpma işlemini gerçekleştir
                                let multipliedCalories = selectedCalories / divisor * Float(grams)
                                let multipliedCarbs = selectedCarbs / divisor * Float(grams)
                                let multipliedFat = selectedFat / divisor * Float(grams)
                                let multipliedProtein = selectedProtein / divisor * Float(grams)

                                // Sonuçları String olarak kaydet
                                newFood.calori = String(multipliedCalories)
                                newFood.carbon = String(multipliedCarbs)
                                newFood.fat = String(multipliedFat)
                                newFood.protein = String(multipliedProtein)

                                newFood.date = datePickerDate
                                
                                // Save the new Breakfast entity to Core Data
                                self.coredata.saveData()
                                
                                // Print added Breakfast entity
                                print("Added Breakfast Entity: \(newFood)")
                                
                                // ... rest of your code
                            } else {
                                // Handle the case when some of the values are nil or conversion fails
                                print("Some values are nil or conversion fails.")
                            }
                        } else {
                            print("Selected food is nil.")
                        }
                        
                    }
                    tableView.reloadData()
                    homeViewController.badgeCount[0] += 1
                    print("Segment 0 selected")
                }
                alertDinner.addAction(cancelAction)
                alertDinner.addAction(addAction)
                
                self?.present(alertDinner, animated: true, completion: nil)
            }
            
            if self?.segmentedControl.selectedSegmentIndex == 1 {
                let datePickerDate = homeViewController.datePicker.date
                self?.selectedCellFoodNameManuel = self?.coredata.foods?[indexPath.row].title
                print("Selected Cell Food Name: \(self?.selectedCellFoodNameManuel ?? "nil")")
                
                if let context = self?.coredata.context {
                    let newFood = Dinner(context: context)
                    newFood.title   = self?.coredata.foods?[indexPath.row].title
                    newFood.calori  = self?.coredata.foods?[indexPath.row].calori
                    newFood.protein = self?.coredata.foods?[indexPath.row].protein
                    newFood.fat     = self?.coredata.foods?[indexPath.row].fat
                    newFood.carbon  = self?.coredata.foods?[indexPath.row].carbon
                    newFood.date    = datePickerDate
                    
                    print("added", "\(newFood.title ?? "0")")
                } else {
                    // Handle the case when the context is nil.
                    print("Error: NSManagedObjectContext is nil.")
                }
                self?.coredata.saveData()
                print("Segment 1 selected")
                homeViewController.badgeCount[0] += 1
            }
            
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
            if self?.segmentedControl.selectedSegmentIndex == 0 {
                let alertSnack = UIAlertController(title: cell.foodTitleLabelUI.text, message: cell.infoLabel.text, preferredStyle: .alert)
                
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
                          let grams = Float(gramText) else {
                        return
                    }
                    
                    
                    //check if list is empty?
                    let keysArray = Array(searchResults.keys)
                    
                    if keysArray.isEmpty {
                        print("Search results are empty.")
                        // Handle the case when there are no search results, e.g., show a message to the user.
                    } else {
                        if indexPath.row < keysArray.count {
                            selectedCellFoodName = keysArray[indexPath.row]
                            print("Selected Cell Food Name: \(selectedCellFoodName ?? "nil")")
                            // ... rest of your code related to selectedCellFoodName
                        } else {
                            print("Index out of range: \(indexPath.row) for keysArray with count \(keysArray.count)")
                            // Handle the case when indexPath.row is out of range.
                        }
                    }
                    
                    
                    // Check if selectedCellFoodName is not nil
                    if let selectedCellFoodName = self.selectedCellFoodName,
                       let existingLastFood = self.coredata.lastSearch?.first(where: { $0.title == selectedCellFoodName }),
                       let nutrientValues = searchResults[selectedCellFoodName] {
                        
                        let divisor: Float = 100.0

                        // Besin öğelerini al
                        let existingCalories = Float(existingLastFood.calori ?? "0.0") ?? 0.0
                        let existingCarbs = Float(existingLastFood.carbon ?? "0.0") ?? 0.0
                        let existingFat = Float(existingLastFood.fat ?? "0.0") ?? 0.0
                        let existingProtein = Float(existingLastFood.protein ?? "0.0") ?? 0.0

                        // Grams ile çarpma işlemini gerçekleştir
                        let multipliedExistingCalories = (existingCalories + (nutrientValues.calories / divisor)) * Float(grams)
                            let multipliedExistingCarbs = (existingCarbs + (nutrientValues.carbs / divisor)) * Float(grams)
                            let multipliedExistingFat = (existingFat + (nutrientValues.fat / divisor)) * Float(grams)
                            let multipliedExistingProtein = (existingProtein + (nutrientValues.protein / divisor)) * Float(grams)

                        // Sonuçları String olarak kaydet
                        existingLastFood.calori = String(multipliedExistingCalories)
                        existingLastFood.carbon = String(multipliedExistingCarbs)
                        existingLastFood.fat = String(multipliedExistingFat)
                        existingLastFood.protein = String(multipliedExistingProtein)

                        
                        // Print updated nutritional values
                        print("Updated Nutrient Values: \(nutrientValues)")
                        
                        // Print updated LastSearch entity
                        print("Updated LastSearch Entity: \(existingLastFood)")
                    } else {
                        // Check if selectedCellFoodName is not nil
                        if let selectedCellFoodName = self.selectedCellFoodName,
                           let nutrientValues = searchResults[selectedCellFoodName] {

                            // If a record with the same title exists, create a new LastSearch entity
                            // instead of updating the existing LastSearch entity
                            let newLastSearch = LastSearch(context: self.coredata.context)
                            newLastSearch.title = selectedCellFoodName
                            newLastSearch.calori = String(format: "%.2f", nutrientValues.calories)
                            newLastSearch.carbon = String(format: "%.2f", nutrientValues.carbs)
                            newLastSearch.fat = String(format: "%.2f", nutrientValues.fat)
                            newLastSearch.protein = String(format: "%.2f", nutrientValues.protein)
                            newLastSearch.info = nutrientValues.info

                            // Print updated nutritional values
                            print("Updated Nutrient Values: \(nutrientValues)")
                            
                            // Create a new Breakfast entity in Core Data
                            self.saveFoodToCoreData(title: selectedCellFoodName, food: nutrientValues, mealEntityName: "Snack", grams: grams)
                            print("saveFoodToCoreData called successfully")
                 
                     
                        } else {
                            // Handle the case when selectedCellFoodName is nil
                            print("selectedCellFoodName is nil")
                        }
                    }
                    if isSearching == false {
                        let datePickerDate = homeViewController.datePicker.date
                        if let selectedFood = self.coredata.lastSearch?[indexPath.row] {
                            let selectedCellFoodNameLast = selectedFood.title
                            print("Selected Cell Food Name: \(selectedCellFoodNameLast ?? "nil")")
                            
                            // ... rest of your code related to selectedCellFoodName
                            
                            // Check if selectedCellFoodName is not nil
                            if let gramsText = alertSnack.textFields?.first?.text,
                               let grams = Float(gramsText) {
                                
                                // Create a new Breakfast entity in Core Data
                                let context = self.coredata.context
                                let newFood = Snack(context: context)
                                newFood.title = selectedCellFoodNameLast
                                let divisor: Float = 100.0

                                // Seçili yemek için bilgileri al
                                let selectedCalories = Float(selectedFood.calori ?? "0.0") ?? 0.0
                                let selectedCarbs = Float(selectedFood.carbon ?? "0.0") ?? 0.0
                                let selectedFat = Float(selectedFood.fat ?? "0.0") ?? 0.0
                                let selectedProtein = Float(selectedFood.protein ?? "0.0") ?? 0.0

                                // Grams ile çarpma işlemini gerçekleştir
                                let multipliedCalories = selectedCalories / divisor * Float(grams)
                                let multipliedCarbs = selectedCarbs / divisor * Float(grams)
                                let multipliedFat = selectedFat / divisor * Float(grams)
                                let multipliedProtein = selectedProtein / divisor * Float(grams)

                                // Sonuçları String olarak kaydet
                                newFood.calori = String(multipliedCalories)
                                newFood.carbon = String(multipliedCarbs)
                                newFood.fat = String(multipliedFat)
                                newFood.protein = String(multipliedProtein)

                                newFood.date = datePickerDate
                                
                                // Save the new Breakfast entity to Core Data
                                self.coredata.saveData()
                                
                                // Print added Breakfast entity
                                print("Added Breakfast Entity: \(newFood)")
                                
                                // ... rest of your code
                            } else {
                                // Handle the case when some of the values are nil or conversion fails
                                print("Some values are nil or conversion fails.")
                            }
                        } else {
                            print("Selected food is nil.")
                        }
                        
                    }
                    tableView.reloadData()
                    homeViewController.badgeCount[0] += 1
                    print("Segment 0 selected")
                }
                alertSnack.addAction(cancelAction)
                alertSnack.addAction(addAction)
                
                self?.present(alertSnack, animated: true, completion: nil)
            }
            
            if self?.segmentedControl.selectedSegmentIndex == 1 {
                let datePickerDate = homeViewController.datePicker.date
                self?.selectedCellFoodNameManuel = self?.coredata.foods?[indexPath.row].title
                print("Selected Cell Food Name: \(self?.selectedCellFoodNameManuel ?? "nil")")
                
                if let context = self?.coredata.context {
                    let newFood = Snack(context: context)
                    newFood.title   = self?.coredata.foods?[indexPath.row].title
                    newFood.calori  = self?.coredata.foods?[indexPath.row].calori
                    newFood.protein = self?.coredata.foods?[indexPath.row].protein
                    newFood.fat     = self?.coredata.foods?[indexPath.row].fat
                    newFood.carbon  = self?.coredata.foods?[indexPath.row].carbon
                    newFood.date    = datePickerDate
                    
                    print("added", "\(newFood.title ?? "0")")
                } else {
                    // Handle the case when the context is nil.
                    print("Error: NSManagedObjectContext is nil.")
                }
                self?.coredata.saveData()
                print("Segment 1 selected")
                homeViewController.badgeCount[0] += 1
            }
            
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            let editOption = UIAlertAction(title: "Edit", style: .default) { _ in
                guard let food = self.coredata.foods?[indexPath.row] else {
                    return
                }
                
                // Edit Row
                let editAlert = UIAlertController(title: "Editor", message: "You can change!", preferredStyle: .alert)
                editAlert.addTextField { textField in
                    textField.placeholder = "Title"
                    textField.text = food.title
                    
                }
                editAlert.addTextField { textField in
                    textField.placeholder = "Protein"
                    textField.text = food.protein
                    textField.keyboardType = .decimalPad
                }
                editAlert.addTextField { textField in
                    textField.placeholder = "Carbon"
                    textField.text = food.carbon
                    textField.keyboardType = .decimalPad
                }
                editAlert.addTextField { textField in
                    textField.placeholder = "Fat"
                    textField.text = food.fat
                    textField.keyboardType = .decimalPad
                }
                editAlert.addTextField { textField in
                    textField.placeholder = "Calories"
                    textField.text = food.calori
                    textField.keyboardType = .decimalPad
                }
                
                // Save button
                let saveButton = UIAlertAction(title: "Edit", style: .default) { (action) in
                    guard let textfieldTitle = editAlert.textFields?[0],
                          let textfieldProtein = editAlert.textFields?[1],
                          let textfieldCarbon = editAlert.textFields?[2],
                          let textfieldFat = editAlert.textFields?[3],
                          let textfieldCalori = editAlert.textFields?[4] else {
                        return
                    }
                    
                    // Edit TextField
                    if var editedTitle = textfieldTitle.text {
                        editedTitle = editedTitle.capitalized // Büyük harfle başlatma işlemi
                        food.title = editedTitle
                    }
                    
                    food.protein = textfieldProtein.text
                    food.carbon = textfieldCarbon.text
                    food.fat = textfieldFat.text
                    food.calori = textfieldCalori.text
                    food.idFood = UUID()
                    
                    self.coredata.saveData()
                    self.coredata.fetchFoods()
                    tableView.reloadData()
                }
                
                // Cancel button
                let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
                
                // Show buttons
                editAlert.addAction(cancelButton)
                editAlert.addAction(saveButton)
                
                self.present(editAlert, animated: true, completion: nil)
            }
            alert.addAction(editOption)
            editOption.setValue(UIColor.systemPink, forKey: "titleTextColor")
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            // Haptic feedback
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            
            if self?.isSearching == false {
                // Eğer searching modu aktif değilse, silme işlemini gerçekleştirin.
                switch selectedSegmentIndex {
                case 0:
                    if let lastSearchToDelete = self?.coredata.lastSearch?[indexPath.row] {
                        self?.coredata.context.delete(lastSearchToDelete)
                        self?.coredata.saveData()
                        self?.coredata.fetchLastSearch()
                    }

                case 1:
                    if let foodToDelete = selectedSegmentIndex == 1 ? self?.coredata.foods?[indexPath.row] : nil {
                        self?.coredata.context.delete(foodToDelete)
                        self?.coredata.saveData()
                        self?.coredata.fetchFoods()
                    }
                default:
                    break
                }
                
                // Update the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                // Eğer searching modu aktifse, burada herhangi bir silme işlemi gerçekleştirmeyebilirsiniz.
                // İsterseniz bir uyarı mesajı veya başka bir işlem ekleyebilirsiniz.
                print("Searching mode is active. Deletion is not allowed.")
            }

            completionHandler(true)
        }
        
        // Set the trash bin image for the delete action and tint it pink
        if let trashImage = UIImage(systemName: "trash")?.withTintColor(.systemPink) {
            deleteAction.image = trashImage
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isSearching
    }
}
// Search Bar
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            // Update searchResults based on the search text
            searchResults = foodDictionary.filter { $0.key.lowercased().contains(searchText.lowercased()) }
            isSearching = true
        } else {
            // If the search bar is empty, show an empty result
            searchResults = [:]
            coredata.fetchLastSearch()
            isSearching = false
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // This function is called when the Cancel button is clicked
        searchBar.text = "" // Clear the content of the search bar
        searchBar.resignFirstResponder() // Close the keyboard
        searchResults = [:] // Clear search results
        isSearching = false
        coredata.fetchLastSearch()
        tableView.reloadData()
    }
}
