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
  
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(helper.filePath)
        helper = Helper()
        helper.fetchFoods()
        helper.fetchFavorite()
    }
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Search Food")
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        
        print("look at info")
    }
    
    @IBAction func favoriFoodsButtonPressed(_ sender: UIButton) {
        if let indexPath = indexPathForButton(sender) {
            if let selectedFood = helper.foods?[indexPath.row] {
                let favored = Favori(context: self.helper.context)
                favored.title = selectedFood.title
                self.helper.saveData()
                print("added to favorite")

                // Provide a single haptic feedback
                generateHapticFeedback(style: .light)
            } else if let selectedFavori = helper.favori?[indexPath.row] {
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
            equalInfo.title = foodTitle!
        
            //Save Data
            self?.helper.saveData()
            //fetch Data
            self?.helper.fetchFoods()
            //call cell
            self?.tableView.reloadData()
        }
        
        //Cancel Button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func segmentButtonPressed(_ sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex

        switch currentSegmentIndex {
        case 0:
            // show foods
            helper.favori = nil
            helper.fetchFoods()
            navigationItem.title = "Food"
        case 1:
            // show favori & hide foods
            helper.foods = nil
            helper.fetchFavorite()
            navigationItem.title = "Favori"
        default:
            break
        }
        // Update the table
        tableView.reloadData()
    }


    
}
//
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let addFoodCount = self.helper.foods?.count, addFoodCount > 0 {
            return addFoodCount
        } else if let favoriteCount = self.helper.favori?.count, favoriteCount > 0 {
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
        } else if let favoriCount = self.helper.favori?.count, favoriCount > 0 {
            let indexFavori = helper.favori?[row]
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

            // Handle the delete action here

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
                if let favoriToDelete = self?.helper.favori?[indexPath.row] {
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



    
    
}
