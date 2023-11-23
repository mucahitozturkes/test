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
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(helper.filePath)
        helper = Helper()
        helper.fetchFoods()
    }

    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        print("Search Foods")
    }
    @IBAction func addNewFoodButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Food", message: "Just write your food", preferredStyle: .alert)
        alert.addTextField()
//        alert.addTextField()
//        alert.addTextField()
//        alert.addTextField()
//        alert.addTextField()
        
        //Add Button Way
        let addButton = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            let foodTitle = alert.textFields?[0].text
//            let protein = alert.textFields?[1].text
//            let carbon = alert.textFields?[2].text
//            let fat = alert.textFields?[3].text
//            let calori = alert.textFields?[4].text
            
            //Equal with Labels
            let equalInfo = Foods(context: (self?.helper.context)!)
            equalInfo.title = foodTitle!
            //equalInfo.protein = pro
            //equalInfo.carbon = car
            //equalInfo.fat = fat
            //equalInfo.calori = calori
            
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
    
}
//
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helper.foods?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let row = indexPath.row
        let indexFoods = helper.foods?[row]
        
        cell.foodTitleLabel?.text = indexFoods?.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            // Handle the delete action here

            // Delete the item from your data source (e.g., CoreData)
            if let foodToDelete = self?.helper.foods?[indexPath.row] {
                self?.helper.context.delete(foodToDelete)
                self?.helper.saveData()
                self?.helper.fetchFoods()

                // Update the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            completionHandler(true)
        }

        // Set the trash bin image for the delete action and tint it pink
        if let trashImage = UIImage(systemName: "trash")?.withTintColor(.systemPink) {
            // Set the trash bin image for the delete action
            deleteAction.image = trashImage

            // Set the background color to white
            deleteAction.backgroundColor = .red
            
        }


        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }


    
    
}
