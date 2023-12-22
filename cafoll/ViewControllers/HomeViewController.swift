//
//  HomeViewController.swift
//  cafoll
//
//  Created by mücahit öztürk on 4.12.2023.
//

import UIKit


class HomeViewController: UIViewController {
    //textfields for popup
    @IBOutlet weak var textfieldCarbon: UITextField!
    @IBOutlet weak var textfieldFat: UITextField!
    @IBOutlet weak var textfieldProtein: UITextField!
    @IBOutlet weak var textfieldCalori: UITextField!
    //Header
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateView: UIView!
    //external View
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var popupTitleV: UIView!
    @IBOutlet weak var popupV4: UIView!
    @IBOutlet weak var popupV3: UIView!
    @IBOutlet weak var popupV2: UIView!
    @IBOutlet weak var popupV1: UIView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet var popupView: UIView!
    //circle
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var firstLook: UIView!
    //right of circle
    @IBOutlet weak var progressGreen: UIProgressView!
    @IBOutlet weak var progressYellow: UIProgressView!
    @IBOutlet weak var progressRed: UIProgressView!
    @IBOutlet weak var progressPurple: UIProgressView!
    @IBOutlet weak var secondLook: UIView!
    //table view
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var coredata: Coredata!
    var helper: Helper!
    var ui: Ui!

    override func viewDidLoad() {
        super.viewDidLoad()
      startUpSetup()
    }
    //start up reactions
    func startUpSetup() {
        //print(helper?.filePath ?? "Not Found")
        helper = Helper()
        coredata = Coredata()
        ui = Ui()
        setLayers()
        //Fetch items
        coredata.fetchBreakfast()
        coredata.fetchLunch()
        coredata.fetchDinner()
        coredata.fetchSnack()
        coredata.fetchMaxValueCircle()
        //UI
        ui.uiTools(homeViewController: self)
        ui.updateButtonTapped()
        firstLook.bringSubviewToFront(settingsButton)
        //out of popup
        gestureView.frame = UIScreen.main.bounds
        gestureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.7, height: self.view.bounds.height * 0.3)
        // Add UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gestureView.addGestureRecognizer(tapGesture)
        //table View Load
        tableView.reloadData()
        // Textfield'ların değişikliklerini dinle
        textfieldCarbon.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldFat.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldProtein.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldCalori.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Butonu başlangıçta devre dışı bırak
        updateButton.isEnabled = false
    }
    //view Shadows
    func setLayers() {
        [popupV1, popupV2, popupV3, popupV4].forEach { $0.layer.cornerRadius = 12 }
        
        popupTitleV.layer.cornerRadius = 12
        popupTitleV.layer.shadowColor = UIColor.lightGray.cgColor
        popupTitleV.layer.shadowOffset = CGSize(width: 0, height: 6)
        popupTitleV.layer.shadowRadius = 8
        popupTitleV.layer.shadowOpacity = 0.1
        
        
    }

    //popup in & out animation
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
            //popup
            popupView.layer.cornerRadius = 12
            popupView.layer.shadowColor = UIColor.lightGray.cgColor
            popupView.layer.shadowOffset = CGSize(width: 0, height: 6)
            popupView.layer.shadowRadius = 12
            popupView.layer.shadowOpacity = 0.2
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
    //gesture
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        animatedOut(desiredView: popupView)
        animatedOut(desiredView: gestureView)
    }
    //circle button
    @IBAction func popupButtonPressed(_ sender: UIButton) {
        animated(desiredView: gestureView)
        animated(desiredView: popupView)
        
        // Assuming you have a reference to your MaxValueCircle instance
        if let maxValueCircle = self.coredata.maxValueCircle?.first {
               // Assuming that you have outlets for your textfields
            textfieldCalori.text = "\(maxValueCircle.maxValueCalori)"
               textfieldProtein.text = "\(maxValueCircle.maxValueProtein)"
               textfieldFat.text = "\(maxValueCircle.maxValueFat)"
               textfieldCarbon.text = "\(maxValueCircle.maxValueCarbon)"
           }
    }

    @IBAction func deleteAllFetchValues(_ sender: UIButton) {
       
        // Delete all existing MaxValueCircle instances
            if let existingMaxValueCircles = self.coredata.maxValueCircle {
                print("Before deletion. Count: \(existingMaxValueCircles.count)")
                for circle in existingMaxValueCircles {
                    coredata.context.delete(circle)
                    print("deleted all fetch Values")
                }
                print("After deletion. Count: \(existingMaxValueCircles.count)")
                coredata.saveData()
            }
        
        coredata.fetchMaxValueCircle()
    }
    //button in external view
    @IBAction func activeButtonPressed(_ sender: UIButton) {
        ui.updateButtonTapped()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isAllFieldsFilled = !(textfieldCarbon.text?.isEmpty ?? true) &&
                                !(textfieldFat.text?.isEmpty ?? true) &&
                                !(textfieldProtein.text?.isEmpty ?? true) &&
                                !(textfieldCalori.text?.isEmpty ?? true)

        updateButton.isEnabled = isAllFieldsFilled
       
    }
    //segment Button
    @IBAction func segmentButtonPressed(_ sender: UISegmentedControl) {
            let currentSegmentIndex = sender.selectedSegmentIndex

            switch currentSegmentIndex {
            case 0:
                coredata.fetchBreakfast()
                sumBreakfast()
            case 1:
                coredata.fetchLunch()
                sumLunch()
            case 2:
                coredata.fetchDinner()
                sumDinner()
            case 3:
                coredata.fetchSnack()
                sumSnack()
            default:
                break
            }
            // Update the table
            tableView.reloadData()
        }
        
    func sumBreakfast() {
        guard let breakfastItems = self.coredata.breakfast else {
            return
        }

        // Calculate the sum of values for calories, fat, protein, and carbohydrates
        var totalCalories = 0.0
        var totalFat = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in breakfastItems {
            totalCalories += Double(item.calori!) ?? 0.0
            totalFat += Double(item.fat!) ?? 0.0
            totalProtein += Double(item.protein!) ?? 0.0
            totalCarbs += Double(item.carbon!) ?? 0.0 // Assuming "carbon" is the property representing carbohydrates
        }

        // Update the progress views with specific maximum values for breakfast
        let maxGreen: Float = 100
        let maxYellow: Float = 200
        let maxRed: Float = 400
        let maxPurple: Float = 700

        updateProgressViews(calories: totalCalories, fat: totalFat, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)
    }

    func sumLunch() {
        guard let lunchItems = self.coredata.lunch else {
            return
        }

        // Calculate the sum of values for calories, fat, protein, and carbohydrates
        var totalCalories = 0.0
        var totalFat = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in lunchItems {
            totalCalories += Double(item.calori!) ?? 0.0
            totalFat += Double(item.fat!) ?? 0.0
            totalProtein += Double(item.protein!) ?? 0.0
            totalCarbs += Double(item.carbon!) ?? 0.0 // Assuming "carbon" is the property representing carbohydrates
        }

        // Update the progress views with specific maximum values for lunch
        let maxGreen: Float = 150
        let maxYellow: Float = 250
        let maxRed: Float = 450
        let maxPurple: Float = 800

        updateProgressViews(calories: totalCalories, fat: totalFat, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)
    }

    func sumDinner() {
        guard let dinnerItems = self.coredata.dinner else {
            return
        }

        // Calculate the sum of values for calories, fat, protein, and carbohydrates
        var totalCalories = 0.0
        var totalFat = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in dinnerItems {
            totalCalories += Double(item.calori!) ?? 0.0
            totalFat += Double(item.fat!) ?? 0.0
            totalProtein += Double(item.protein!) ?? 0.0
            totalCarbs += Double(item.carbon!) ?? 0.0 // Assuming "carbon" is the property representing carbohydrates
        }

        // Update the progress views with specific maximum values for dinner
        let maxGreen: Float = 120
        let maxYellow: Float = 220
        let maxRed: Float = 380
        let maxPurple: Float = 600

        updateProgressViews(calories: totalCalories, fat: totalFat, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)
    }

    func sumSnack() {
        guard let snackItems = self.coredata.snack else {
            return
        }

        // Calculate the sum of values for calories, fat, protein, and carbohydrates
        var totalCalories = 0.0
        var totalFat = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in snackItems {
            totalCalories += Double(item.calori!) ?? 0.0
            totalFat += Double(item.fat!) ?? 0.0
            totalProtein += Double(item.protein!) ?? 0.0
            totalCarbs += Double(item.carbon!) ?? 0.0 // Assuming "carbon" is the property representing carbohydrates
        }

        // Update the progress views with specific maximum values for snack
        let maxGreen: Float = 90
        let maxYellow: Float = 180
        let maxRed: Float = 300
        let maxPurple: Float = 500

        updateProgressViews(calories: totalCalories, fat: totalFat, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)
    }
        
    func updateProgressViews(calories: Double, fat: Double, protein: Double, carbs: Double, maxGreen: Float, maxYellow: Float, maxRed: Float, maxPurple: Float) {
        // Update progress views based on the calculated sum for each nutrient
        progressGreen.progress = min(Float(calories) / maxGreen, 1.0)
        progressYellow.progress = min(Float(fat) / maxYellow, 1.0)
        progressRed.progress = min(Float(protein) / maxRed, 1.0)
        progressPurple.progress = min(Float(carbs) / maxPurple, 1.0)
    }


    // Helper function to determine the highest value and return the corresponding color
    func determineHighestValueColor(calori: Double, fat: Double, protein: Double, carbon: Double) -> UIColor {
        var highestValueColor: UIColor = .clear

        let maxValue = max(calori, fat, protein, carbon)

        if maxValue == calori {
            highestValueColor = .green
        } else if maxValue == fat {
            highestValueColor = .brown
        } else if maxValue == protein {
            highestValueColor = .red
        } else if maxValue == carbon {
            highestValueColor = .purple
        }

        return highestValueColor
    }



}
// MARK: - Home Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segment.selectedSegmentIndex {
        case 0:
            print("Breakfast count: ", self.coredata.breakfast?.first ?? "0")
            return self.coredata.breakfast?.count ?? 0
        case 1:
            print("Lunch count: ", self.coredata.lunch?.first ?? "0")
            return self.coredata.lunch?.count ?? 0
        case 2:
            print("Dinner count: ", self.coredata.dinner?.first ?? "0")
            return self.coredata.dinner?.count ?? 0
        case 3:
            print("Snack count: ", self.coredata.snack?.first ?? "0")
            return self.coredata.snack?.count ?? 0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let row = indexPath.row
        
        var highestValueColor: UIColor = .clear
        
        switch segment.selectedSegmentIndex {
        case 0:
            if let indexBreakfast = self.coredata.breakfast?[row] {
                cell.titleLabel?.text = indexBreakfast.title
                highestValueColor = determineHighestValueColor(carbons: indexBreakfast.carbon!, fat: indexBreakfast.fat!, protein: indexBreakfast.protein!)
            }
        case 1:
            if let indexLunch = self.coredata.lunch?[row] {
                cell.titleLabel?.text = indexLunch.title
                highestValueColor = determineHighestValueColor(carbons: indexLunch.carbon!, fat: indexLunch.fat!, protein: indexLunch.protein!)
            }
        case 2:
            if let indexDinner = self.coredata.dinner?[row] {
                cell.titleLabel?.text = indexDinner.title
                highestValueColor = determineHighestValueColor(carbons: indexDinner.carbon!, fat: indexDinner.fat!, protein: indexDinner.protein!)
            }
        case 3:
            if let indexSnack = self.coredata.snack?[row] {
                cell.titleLabel?.text = indexSnack.title
                highestValueColor = determineHighestValueColor(carbons: indexSnack.carbon!, fat: indexSnack.fat!, protein: indexSnack.protein!)
            }
        default:
            break
        }
        
        // Set the background color of colorView based on the highest value
        cell.colorView.backgroundColor = highestValueColor
        
        return cell
    }

    // Helper function to determine the highest value and return the corresponding color
    func determineHighestValueColor(carbons: String, fat: String, protein: String) -> UIColor {
        var highestValueColor: UIColor = .clear
        
        // Convert string representations to doubles
        if let calorieValue = Double(carbons), let fatValue = Double(fat), let proteinValue = Double(protein) {
            let maxValue = max(calorieValue, fatValue, proteinValue)
            
            if maxValue == calorieValue {
                highestValueColor = .systemGreen
            } else if maxValue == fatValue {
                highestValueColor = .systemYellow
            } else if maxValue == proteinValue {
                highestValueColor = .systemRed
            }
        }
        
        return highestValueColor
    }


    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            // Handle deletion logic here
            self?.deleteItem(at: indexPath)
            completionHandler(true)
        }
        
        // Customize the appearance of the delete action if needed
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false // Swipe only triggers the delete action
        
        return swipeConfig
    }
    //helper for deleting
    func deleteItem(at indexPath: IndexPath) {
        let context = coredata.context

        switch segment.selectedSegmentIndex {
        case 0:
            if let breakfastItem = self.coredata.breakfast?[indexPath.row] {
                context.delete(breakfastItem)
                self.coredata.breakfast?.remove(at: indexPath.row)
            }
        case 1:
            if let lunchItem = self.coredata.lunch?[indexPath.row] {
                context.delete(lunchItem)
                self.coredata.lunch?.remove(at: indexPath.row)
            }
        case 2:
            if let dinnerItem = self.coredata.dinner?[indexPath.row] {
                context.delete(dinnerItem)
                self.coredata.dinner?.remove(at: indexPath.row)
            }
        case 3:
            if let snackItem = self.coredata.snack?[indexPath.row] {
                context.delete(snackItem)
                self.coredata.snack?.remove(at: indexPath.row)
            }
        default:
            break
        }

        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            // Handle the error appropriately
            print("Error deleting item: \(error.localizedDescription)")
        }
    }
}
