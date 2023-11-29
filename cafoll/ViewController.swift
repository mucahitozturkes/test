//
//  ViewController.swift
//  cafoll
//
//  Created by mücahit öztürk on 22.11.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var helper: Helper!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caloriLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbonLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    //Bar
    @IBOutlet weak var caloriBar: UIProgressView!
    @IBOutlet weak var fatBar: UIProgressView!
    @IBOutlet weak var carbonBar: UIProgressView!
    @IBOutlet weak var proteinBar: UIProgressView!
    //popup
    @IBOutlet var popupView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(helper.filePath)
        helper = Helper()
        helper.fetchFoods()
        helper.fetchFavorite()
     
        blurView.bounds = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.7, height: self.view.bounds.height * 0.3)
        
        // UITapGestureRecognizer ekleyin
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
               blurView.addGestureRecognizer(tapGesture)
     
       
    }
    func updateProgressBars(protein: Float, carbon: Float, fat: Float, calories: Float) {
        let maxProtein: Float = 35.0  // Protein maksimum değeri
        let maxCarbon: Float = 25.0   // Karbonhidrat maksimum değeri
        let maxFat: Float = 25.0      // Yağ maksimum değeri
        let maxCalories: Float = 500.0 // Kalori maksimum değeri

        // Protein bar
        proteinBar.progress = protein / maxProtein

        // Karbonhidrat bar
        carbonBar.progress = carbon / maxCarbon

        // Yağ bar
        fatBar.progress = fat / maxFat

        // Kalori bar
        caloriBar.progress = calories / maxCalories
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
           animatedOut(desiredView: popupView)
           animatedOut(desiredView: blurView)
       }
    
    @IBAction func popupButtonPressed(_ sender: UIButton) {
        animated(desiredView: blurView)
        animated(desiredView: popupView)
        
        guard let indexPath = indexPathForRow(sender) else { return }

        var food: Any?

        if let selectedFood = helper.foods?[indexPath.row] {
            food = selectedFood
        } else if let selectedFavorite = helper.favorite?[indexPath.row] {
            food = selectedFavorite
        }
        
        if let food = food {
            var foodName = (food as? Foods)?.title ?? (food as? Favorite)?.title ?? "Unknown"
            var protein = (food as? Foods)?.protein ?? (food as? Favorite)?.protein ?? "0"
            var carbon = (food as? Foods)?.carbon ?? (food as? Favorite)?.carbon ?? "0"
            var fat = (food as? Foods)?.fat ?? (food as? Favorite)?.fat ?? "0"
            var calori = (food as? Foods)?.calori ?? (food as? Favorite)?.calori ?? "0"
            
            titleLabel.text = foodName
            proteinLabel.text = protein
            carbonLabel.text = carbon
            fatLabel.text = fat
            caloriLabel.text = calori
            
            // Progress barları güncelle
            updateProgressBars(protein: Float(protein) ?? 0.0,
                               carbon: Float(carbon) ?? 0.0,
                               fat: Float(fat) ?? 0.0,
                               calories: Float(calori) ?? 0.0)
        }
    }

    
    func animated(desiredView: UIView) {
        let backgroundView = self.view!
            
        //popupView.backgroundColor = UIColor.white
        popupView.layer.cornerRadius = 12
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.shadowOffset = CGSize(width: 0, height: 2)
        popupView.layer.shadowRadius = 4
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1, y: 0.1)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.5, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1, y: 1)
            desiredView.alpha = 1
            
        })
    }
    func animatedOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            desiredView.alpha = 0
        },completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    

    // Helper method to get the indexPath for the button pressed
    private func indexPathForRow(_ button: UIButton) -> IndexPath? {
        let point = button.convert(CGPoint.zero, to: tableView)
        return tableView.indexPathForRow(at: point)
    }


    @IBAction func favoriFoodsButtonPressed(_ sender: UIButton) {
        if let indexPath = indexPathForButton(sender) {
            if let selectedFood = helper.foods?[indexPath.row] {
                let favored = Favorite(context: self.helper.context)
                favored.title = selectedFood.title
                favored.protein = selectedFood.protein
                favored.carbon = selectedFood.carbon
                favored.fat = selectedFood.fat
                favored.calori = selectedFood.calori
                self.helper.saveData()
                
                print("added to favorite")

                // Provide a single haptic feedback
                helper.generateHapticFeedback(style: .light)
            } else if let selectedFavori = helper.favorite?[indexPath.row] {
                self.helper.context.delete(selectedFavori)
                self.helper.saveData()
                self.helper.fetchFavorite()
                
                print("remove from favori")

                // Provide a single haptic feedback
                helper.generateHapticFeedback(style: .light)
            }
        }
    }

    func indexPathForButton(_ button: UIButton) -> IndexPath? {
        let buttonPosition = button.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
    @IBAction func addNewFoodButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Food", message: "Just write your food", preferredStyle: .alert)

        alert.addTextField { textfield in
            textfield.placeholder = " + Food"
            textfield.textAlignment = .center
            
        }
        alert.addTextField { textfield in
            textfield.placeholder = " + Protein"
            textfield.keyboardType = .decimalPad
        }
        alert.addTextField { textfield in
            textfield.placeholder = " + Carbon"
            textfield.keyboardType = .decimalPad
        }
        alert.addTextField { textfield in
            textfield.placeholder = " + Fat"
            textfield.keyboardType = .decimalPad
        }
        alert.addTextField { textfield in
            textfield.placeholder = " + Calori"
            textfield.keyboardType = .decimalPad
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
            let equalInfo = Foods(context: (self?.helper.context)!)
            equalInfo.title = foodTitle?.capitalized
            equalInfo.protein = foodProtein
            equalInfo.carbon = foodCarbon
            equalInfo.fat = foodFat
            equalInfo.calori = foodCalori

            // Save Data
            self?.helper.saveData()
            // Fetch Data
            self?.helper.fetchFoods()
            // Reverse the array to show the most recently added items at the top
            self?.helper.foods?.reverse()
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

    
    @IBAction func segmentButtonPressed(_ sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex

        switch currentSegmentIndex {
        case 0:
            // show foods
            helper.favorite = nil
            helper.fetchFoods()
            // Reverse the array to show the most recently added items at the top
            self.helper.foods?.reverse()
            navigationItem.title = "Food"
            let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewFoodButtonPressed))
                    addButton.tintColor = UIColor.darkGray  // Set the color you want
                    navigationItem.rightBarButtonItem = addButton
        case 1:
            // show favori & hide foods
            helper.foods = nil
            helper.fetchFavorite()
            // Reverse the array to show the most recently added items at the top
            self.helper.favorite?.reverse()
            navigationItem.title = "Favorite"
            navigationItem.rightBarButtonItem = nil
            
        default:
            break
        }
        // Update the table
        tableView.reloadData()
    }
    

}
//MARK: - Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let addFoodCount = self.helper.foods?.count, addFoodCount > 0 {
            return addFoodCount
        } else if let favoriteCount = self.helper.favorite?.count, favoriteCount > 0 {
            return favoriteCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let row = indexPath.row
        
        if let addFoodCount = self.helper.foods?.count, addFoodCount > 0 {
            let indexFoods = helper.foods?[row]
            cell.foodTitleLabel?.text = indexFoods?.title
            cell.favoriteButton.isUserInteractionEnabled = true // enable interaction
        } else if let favoriCount = self.helper.favorite?.count, favoriCount > 0 {
            let indexFavori = helper.favorite?[row]
            cell.foodTitleLabel.text = indexFavori?.title
            cell.favoriteButton.isUserInteractionEnabled = false // Disable interaction
        }
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            // Haptic feedback
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            
            // Assuming you have a property named segmentedControl
            let selectedSegmentIndex = self?.segmentedControl.selectedSegmentIndex ?? 0
            
            switch selectedSegmentIndex {
            case 0:
                // Delete from foods
                if let foodToDelete = self?.helper.foods?[indexPath.row] {
                    // Check if there is a corresponding favorite item
                    if let favoriteToDelete = self?.helper.favorite?.first(where: { $0.id == foodToDelete.id }) {
                        // Delete the corresponding favorite item
                        self?.helper.context.delete(favoriteToDelete)
                        self?.helper.saveData()
                        self?.helper.fetchFavorite() // Make sure to fetch favorites after deletion
                    }
                    
                    // Delete the food item
                    self?.helper.context.delete(foodToDelete)
                    self?.helper.saveData()
                    self?.helper.fetchFoods()
                }

            case 1:
                // Delete from favori
                if let favoriToDelete = self?.helper.favorite?[indexPath.row] {
                    // Delete the favorite item
                    self?.helper.context.delete(favoriToDelete)
                    self?.helper.saveData()
                    self?.helper.fetchFavorite()
                }
            default:
                break
            }
            
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        // Set the trash bin image for the delete action and tint it pink
        if let trashImage = UIImage(systemName: "trash")?.withTintColor(.systemPink) {
            // Set the trash bin image for the delete action
            deleteAction.image = trashImage
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        
        let alert = UIAlertController(title: "Food Options", message: "Select an option", preferredStyle: .actionSheet)
        
        // Options for selecting food type
        let breakfastOption = UIAlertAction(title: "Breakfast", style: .default) { [weak self] _ in
            self?.handleFoodOptionSelection("Breakfast", for: selectedRow)
        }
        
        let lunchOption = UIAlertAction(title: "Lunch", style: .default) { [weak self] _ in
            self?.handleFoodOptionSelection("Lunch", for: selectedRow)
        }
        
        let dinnerOption = UIAlertAction(title: "Dinner", style: .default) { [weak self] _ in
            self?.handleFoodOptionSelection("Dinner", for: selectedRow)
        }
        
        let snackOption = UIAlertAction(title: "Snack", style: .default) { [weak self] _ in
            self?.handleFoodOptionSelection("Snack", for: selectedRow)
        }
        if segmentedControl.selectedSegmentIndex != 1 {
            let editOption = UIAlertAction(title: "Edit", style: .default) { _ in
                guard let food = self.helper.foods?[indexPath.row] else {
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
                    food.title = textfieldTitle.text
                    food.protein = textfieldProtein.text
                    food.carbon = textfieldCarbon.text
                    food.fat = textfieldFat.text
                    food.calori = textfieldCalori.text
                    
                    self.helper.saveData()
                    self.helper.fetchFoods()
                    self.helper.fetchFavorite()
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
            // You can set the text color of the "Edit" option in the first alert here
                    //editOption.setValue(UIColor.darkGray, forKey: "titleTextColor")
            
        }
        // Add actions to the alert
        alert.addAction(breakfastOption)
        alert.addAction(lunchOption)
        alert.addAction(dinnerOption)
        alert.addAction(snackOption)
        // You can set the text color of the "Edit" option in the first alert here
                breakfastOption.setValue(UIColor.darkGray, forKey: "titleTextColor")
        // You can set the text color of the "Edit" option in the first alert here
                lunchOption.setValue(UIColor.darkGray, forKey: "titleTextColor")
        // You can set the text color of the "Edit" option in the first alert here
                dinnerOption.setValue(UIColor.darkGray, forKey: "titleTextColor")
        // You can set the text color of the "Edit" option in the first alert here
                snackOption.setValue(UIColor.darkGray, forKey: "titleTextColor")
      
        
        // Cancel Button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle cancel action if needed
        }
        cancelButton.setValue(UIColor.red, forKey: "titleTextColor") // Set text color to red
        alert.addAction(cancelButton)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
        
        // Deselect the selected row to visually indicate the tap
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Helper method to handle food type option selection
    private func handleFoodOptionSelection(_ option: String, for selectedRow: Int) {
        // Implement your logic based on the selected option and the selected row
        print("Selected option: \(option) for row: \(selectedRow)")
        // You can perform additional actions based on the selected option and row
    }
}
//MARK: - SearchBar
extension ViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // Dismiss the keyboard
            searchBar.resignFirstResponder()
            
            // Clear the search text
            searchBar.text = nil
            
            // Reload the table view with the original data
            helper.fetchFoods()
            helper.fetchFavorite()
            tableView.reloadData()
            
        }
    //search Foods & favoriteis
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, show all data
            helper.fetchFoods()
            helper.fetchFavorite()
        } else {
            // If there is search text, filter the data based on the search text
            helper.foods = helper.foods?.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
            helper.favorite = helper.favorite?.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        // Update the table view with the filtered data
        tableView.reloadData()
    }
}
