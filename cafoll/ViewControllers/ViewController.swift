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
  
    @IBOutlet weak var addButton: UIButton!
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
        tableView.reloadData()
        addButton.isHidden = true
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
            return searchResults.count
        case 1:
            coredata.fetchFoods()
            return  self.coredata.foods?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        let row = indexPath.row
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let foodTitle = Array(searchResults.keys)[indexPath.row]
            cell.foodTitleLabelUI?.text = foodTitle
        case 1:
            let indexFavorite = self.coredata.foods?[row]
            cell.foodTitleLabelUI.text = indexFavorite?.title
        
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
                       var nutrientValues = searchResults[selectedCellFoodName] {
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
                    
                    if let selectedCellFoodNameManuel = self?.selectedCellFoodNameManuel,
                       let context = self?.coredata.context {
                        let newFood = Breakfast(context: context)
                        newFood.title   = self?.coredata.foods?[indexPath.row].title
                        newFood.calori  = self?.coredata.foods?[indexPath.row].calori
                        newFood.protein = self?.coredata.foods?[indexPath.row].protein
                        newFood.fat     = self?.coredata.foods?[indexPath.row].fat
                        newFood.carbon  = self?.coredata.foods?[indexPath.row].carbon
                        newFood.date    = Date()
                        
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
                   var nutrientValues = searchResults[selectedCellFoodName] {
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
                   var nutrientValues = searchResults[selectedCellFoodName] {
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
                   var nutrientValues = searchResults[selectedCellFoodName] {
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
              
                tableView.reloadData()
                homeViewController.badgeCount[0] += 1
                
                
            }
            
            alertSnack.addAction(cancelAction)
            alertSnack.addAction(addAction)
            
            print("Presenting alertBreakfast")
            self?.present(alertSnack, animated: true, completion: nil)
            print("Alert presented")
            
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
                    self.coredata.fetchFavorite()
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
        
        if selectedSegmentIndex == 0 {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            // Haptic feedback
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            
            // Diğer durumları işle...
            switch selectedSegmentIndex {
            case 1:
                let foodToDelete = self?.coredata.foods?[indexPath.row]
                self?.coredata.context.delete(foodToDelete!)
                self?.coredata.saveData()
                self?.coredata.fetchFoods()
            default:
                break
            }
            
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        // Set the trash bin image for the delete action and tint it pink
        if let trashImage = UIImage(systemName: "trash")?.withTintColor(.systemPink) {
            deleteAction.image = trashImage
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

}
//Search Bar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            // Update searchResults based on the search text
            searchResults = foodDictionary.filter { $0.key.lowercased().contains(searchText.lowercased()) }
                .mapValues { nutrientValues in
                    nutrientValues.mapValues { value in
                        // Convert values to String for comparison with searchText
                        Int(value)
                    }
                }
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
