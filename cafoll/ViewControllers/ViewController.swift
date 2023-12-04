//
//  ViewController.swift
//  cafoll
//
//  Created by Mücahit Öztürk on 22.11.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var helper: Helper!
    var coredata: Coredata!
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
    // Popup
    @IBOutlet var gestureView: UIView!
    @IBOutlet var popupView: UIView!
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(helper?.filePath ?? "Not Found")
        helper = Helper()
        coredata = Coredata()
        coredata.fetchFoods()
        coredata.fetchFavorite()

        titleLabelTextfield.layer.cornerRadius = 12
        titleLabelTextfield.layer.shadowColor = UIColor.black.cgColor
        titleLabelTextfield.layer.shadowOffset = CGSize(width: 1, height: 1)
        titleLabelTextfield.layer.shadowRadius = 1
        titleLabelTextfield.layer.shadowOpacity = 0.3
       
        gestureView.frame = UIScreen.main.bounds
        gestureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.7, height: self.view.bounds.height * 0.3)
      
        navigationItem.leftBarButtonItem = .none
        // Add UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gestureView.addGestureRecognizer(tapGesture)
        tableView.reloadData()
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        animatedOut(desiredView: popupView)
        animatedOut(desiredView: gestureView)
    }

    func animated(desiredView: UIView) {
        let backgroundView = self.view!

        popupView.layer.cornerRadius = 12
        
        // Update the shadow color
        if backgroundView.traitCollection.userInterfaceStyle == .dark {
            // White shadow color in Dark mode
            popupView.layer.borderColor = UIColor.lightGray.cgColor
            popupView.layer.borderWidth = 1
        } else {
            // Black shadow color in Light mode
            popupView.layer.borderColor = UIColor.lightGray.cgColor
            popupView.layer.borderWidth = 1
        }

        backgroundView.addSubview(desiredView)

        desiredView.transform = CGAffineTransform(scaleX: 1, y: 0.1)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center

        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1, y: 1)
            desiredView.alpha = 1
        })
    }
    
    func animatedOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }

    func updateProgressBars(protein: Float, carbon: Float, fat: Float, calories: Float) {
        let maxProtein: Float = 35.0  // Maximum value for Protein
        let maxCarbon: Float = 25.0   // Maximum value for Carbohydrates
        let maxFat: Float = 25.0      // Maximum value for Fat
        let maxCalories: Float = 500.0 // Maximum value for Calories

        // Protein bar
        proteinBar.progress = protein / maxProtein

        // Carbohydrate bar
        carbonBar.progress = carbon / maxCarbon

        // Fat bar
        fatBar.progress = fat / maxFat

        // Calorie bar
        caloriBar.progress = calories / maxCalories
    }
    
    @IBAction func popupButtonPressed(_ sender: UIButton) {
        animated(desiredView: gestureView)
        animated(desiredView: popupView)
        
        guard let indexPath = indexPathForRow(sender) else { return }

        var food: Any?

        if let selectedFood = coredata.foods?[indexPath.row] {
            food = selectedFood
           
        } else if let selectedFavorite = coredata.favorite?[indexPath.row] {
            food = selectedFavorite
        }
        
        if let food = food {
            let foodName = (food as? Foods)?.title ?? (food as? Favorite)?.title ?? "Unknown"
            let protein = (food as? Foods)?.protein ?? (food as? Favorite)?.protein ?? "0"
            let carbon = (food as? Foods)?.carbon ?? (food as? Favorite)?.carbon ?? "0"
            let fat = (food as? Foods)?.fat ?? (food as? Favorite)?.fat ?? "0"
            let calori = (food as? Foods)?.calori ?? (food as? Favorite)?.calori ?? "0"
            
            // titleLabelButton
            titleLabelTextfield.text = foodName
            proteinLabel.text = protein
            carbonLabel.text = carbon
            fatLabel.text = fat
            caloriLabel.text = calori
            
            // Update progress bars
            updateProgressBars(protein: Float(protein) ?? 0.0,
                               carbon: Float(carbon) ?? 0.0,
                               fat: Float(fat) ?? 0.0,
                               calories: Float(calori) ?? 0.0)
        }
    }

    private func indexPathForRow(_ button: UIButton) -> IndexPath? {
        let point = button.convert(CGPoint.zero, to: tableView)
        return tableView.indexPathForRow(at: point)
    }
    
    @IBAction func favoriFoodsButtonPressed(_ sender: UIButton) {
        guard let indexPath = indexPathForButton(sender),
              let selectedFood = coredata.foods?[indexPath.row] as? Foods,
              let cell = tableView.cellForRow(at: indexPath) as? Cell else {
            return
        }
        
        let isFavorite = isFoodInFavorites(selectedFood, forSegment: segmentedControl.selectedSegmentIndex)

        // Check if the selected food is already in favorites, if so, remove it
        if isFavorite {
            animateHeartButton(sender)
            return
        }
        
        // When the favorite button is pressed
        cell.favoriteIndicatorUI.startAnimating() // Start the indicator
        cell.favoriteButtonUI.isHidden = true // Hide the favorite button
        
        // Use DispatchQueue to return to the original state after a specific duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // After 0.5 seconds
            cell.favoriteIndicatorUI.stopAnimating() // Stop the indicator
            cell.favoriteButtonUI.isHidden = false // Show the favorite button
        }
        
        // If the food is not in favorites, add it
        let favoriteItem = selectedFood.asFavorite()
        coredata.favorite?.append(favoriteItem)
        helper.generateHapticFeedback(style: .light)
        print(favoriteItem.title!, " Added to favorites")
        coredata.saveData()
        
        // Animation
        let heartImageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        heartImageView.tintColor = .red
        heartImageView.alpha = 0.5
        heartImageView.contentMode = .scaleAspectFit

        // Set the starting point for the animation (middle-left corner of the cell)
        let startingPoint = cell.contentView.convert(cell.contentView.bounds.origin, to: view)
        heartImageView.frame = CGRect(x: startingPoint.x, y: startingPoint.y, width: 80, height: 80)
        view.addSubview(heartImageView)
        UIView.animate(withDuration: 0.3, animations: {
            heartImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            heartImageView.tintColor = .systemRed
            heartImageView.frame = CGRect(x: startingPoint.x + 155, y: startingPoint.y - 0, width: 60, height: 60)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                heartImageView.transform = CGAffineTransform.identity
                heartImageView.center = CGPoint(x: self.view.bounds.width / 1.45, y: self.view.bounds.height - 150)
            }, completion: { _ in
                heartImageView.removeFromSuperview()
            })
        })
    }
    func animateHeartButton(_ button: UIButton) {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "position.x")
        shakeAnimation.values = [0, 10, -10, 10, -5, 5, -2, 2, 0]
        shakeAnimation.keyTimes = [0, 0.1, 0.2, 0.3, 0.5, 0.6, 0.8, 0.9, 1]

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [shakeAnimation]
        animationGroup.duration = 0.4

        button.layer.add(animationGroup, forKey: "shakeAnimation")
    }
    func isFoodInFavorites(_ food: Foods, forSegment segmentIndex: Int) -> Bool {
        if segmentIndex == 0 {
            return coredata.favorite?.contains(where: { $0.idFavorite == food.idFood }) ?? false
        } else if segmentIndex == 1, let favorites = coredata.favorite {
            return favorites.contains(where: { $0.idFavorite == food.idFood })
        }
        return false
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
            equalInfo.idFood = UUID()

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

    @IBAction func segmentButtonPressed(_ sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex

        switch currentSegmentIndex {
        case 0:
            coredata.fetchFoods()
            navigationItem.title = "Food"
            let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewFoodButtonPressed))
                    addButton.tintColor = UIColor.darkGray  // Set the color you want
                    navigationItem.rightBarButtonItem = addButton
            navigationItem.leftBarButtonItem = .none
        case 1:
            navigationItem.title = "Favorite"
            let delete = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAllFavorited))
                    delete.tintColor = UIColor.darkGray  // Set the color you want
                    navigationItem.leftBarButtonItem = delete
                navigationItem.rightBarButtonItem = .none
            coredata.fetchFavorite()
        default:
            break
        }
        // Update the table
        tableView.reloadData()
    }

    @IBAction func deleteAllFavorited(_ sender: UIBarButtonItem) {

        let alertController = UIAlertController(
            title: "Delete All Favorites",
            message: "Are you sure you want to remove all favorited foods?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.performDeletion()
        }
        alertController.addAction(deleteAction)

     

        present(alertController, animated: true, completion: nil)
    }
    private func performDeletion() {
        guard let favoritedItems = coredata.favorite else {
            return
        }

        for favoritedItem in favoritedItems {
            coredata.context.delete(favoritedItem)
        }

        coredata.favorite?.removeAll()
        self.coredata.saveData()
        coredata.fetchFavorite()

        // Reload your data or update your UI as needed
        helper.generateHapticFeedback(style: .heavy)
        tableView.reloadData()

    }
}

//MARK: - Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return self.coredata.foods?.count ?? 0
        case 1:
            return self.coredata.favorite?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let row = indexPath.row

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if let indexFoods = self.coredata.foods?[row] {
                cell.foodTitleLabelUI?.text = indexFoods.title
                cell.favoriteButtonUI.isUserInteractionEnabled = true // enable interaction
                // Set the correct state based on whether it's a favorite or not
                cell.favoriteButtonUI.isSelected = isFoodInFavorites(indexFoods, forSegment: 0)
            }
        case 1:
            if let indexFavorite = self.coredata.favorite?[row] {
                cell.foodTitleLabelUI.text = indexFavorite.title
                cell.favoriteButtonUI.isUserInteractionEnabled = false // Disable interaction
                // Set the correct state based on whether it's a favorite or not
                cell.favoriteButtonUI.isSelected = true
            }
        default:
            break
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
                if let foodToDelete = self?.coredata.foods?[indexPath.row] {
                    // Check if there is a corresponding favorite item
                    if let favoriteToDelete = self?.coredata.favorite?.first(where: { $0.id == foodToDelete.id }) {
                        // Delete the corresponding favorite item
                        self?.coredata.context.delete(favoriteToDelete)
                        self?.coredata.saveData()
                        self?.coredata.fetchFavorite() // Make sure to fetch favorites after deletion
                    }
                    
                    // Delete the food item
                    self?.coredata.context.delete(foodToDelete)
                    self?.coredata.saveData()
                    self?.coredata.fetchFoods()
                }

            case 1:
                // Delete from favori
                if let favoriToDelete = self?.coredata.favorite?[indexPath.row] {
                    // Delete the favorite item
                    self?.coredata.context.delete(favoriToDelete)
                    self?.coredata.saveData()
                    self?.coredata.fetchFavorite()
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

        // Reset the data source to the original data
        coredata.fetchFoods()
        coredata.fetchFavorite()

        // Reload the table view with the original data
        tableView.reloadData()
    }

    //search Foods & favoriteis
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, show all data
            coredata.fetchFoods()
            coredata.fetchFavorite()
        } else {
            // If there is search text, filter the data based on the search text
            let filteredFoods = coredata.foods?.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
            let filteredFavorites = coredata.favorite?.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }

            // Update the data source with the filtered data
            coredata.foods = filteredFoods
            coredata.favorite = filteredFavorites
        }

        // Update the table view with the filtered data
        tableView.reloadData()
    }

}
