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
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(helper.filePath)
        helper = Helper()
        helper.fetchFoods()
        helper.fetchFavorite()
    }
   
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        if let indexPath = indexPathForRow(sender) {
            let foodName = self.helper.foods?[indexPath.row].title
            let foodDescription = "A delicious dish with various toppings."
            let protein = "Protein: 10"
            let carbon = "Carbohydrates: 20"
            let fat = "Fat: 30"
            let calori = "Calories: 40"
            
            let alert = UIAlertController(title: "\(foodName ?? "Unknown")", message: "\(foodDescription)\n\n\(protein)\n\(carbon)\n\(fat)\n\(calori)", preferredStyle: .alert)

            // Cancel Button
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    // Handle cancel action if needed
                }
                cancelButton.setValue(UIColor.red, forKey: "titleTextColor") // Set text color to red
                alert.addAction(cancelButton)

            present(alert, animated: true, completion: nil)
        }
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
                self.helper.saveData()
                print("added to favorite")

                // Provide a single haptic feedback
                generateHapticFeedback(style: .light)
            } else if let selectedFavori = helper.favorite?[indexPath.row] {
                self.helper.context.delete(selectedFavori)
                self.helper.saveData()
                self.helper.fetchFavorite()
                
                print("remove from favori")

                // Provide a single haptic feedback
                generateHapticFeedback(style: .light)
            }
        }
    }

    func generateHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
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
            textfield.placeholder = "Which food do want to add?"
        }
        //Add Button Way
        let addButton = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            let foodTitle = alert.textFields?[0].text
            
            //Equal with Labels
            let equalInfo = Foods(context: (self?.helper.context)!)
            equalInfo.title = foodTitle!.capitalized
            //Save Data
            self?.helper.saveData()
            //fetch Data
            self?.helper.fetchFoods()
            // Reverse the array to show the most recently added items at the top
            self?.helper.foods?.reverse()
            //call cell
            self?.tableView.reloadData()
        }
        
        // Cancel Button
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                // Handle cancel action if needed
            }
            cancelButton.setValue(UIColor.red, forKey: "titleTextColor") // Set text color to red
            alert.addAction(cancelButton)
        
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
        case 1:
            // show favori & hide foods
            helper.foods = nil
            helper.fetchFavorite()
            // Reverse the array to show the most recently added items at the top
            self.helper.favorite?.reverse()
            navigationItem.title = "Favorite"
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
                    self?.helper.context.delete(foodToDelete)
                    self?.helper.saveData()
                    self?.helper.fetchFoods()
                }
            case 1:
                // Delete from favori
                if let favoriToDelete = self?.helper.favorite?[indexPath.row] {
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

        let editFavoriteOption = UIAlertAction(title: "Edit Favorite", style: .default) { [weak self] _ in
            self?.handleFoodOptionSelection("Edit Favorite", for: selectedRow)
        }

        // Add actions to the alert
        alert.addAction(breakfastOption)
        alert.addAction(lunchOption)
        alert.addAction(dinnerOption)
        alert.addAction(snackOption)
        alert.addAction(editFavoriteOption)

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
