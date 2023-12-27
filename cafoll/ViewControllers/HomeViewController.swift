//
//  HomeViewController.swift
//  cafoll
//
//  Created by mücahit öztürk on 4.12.2023.
//

import UIKit

class HomeViewController: UIViewController,UITabBarControllerDelegate {
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
    @IBOutlet weak var stackViewValues: UIStackView!
    @IBOutlet weak var totalCarbon: UILabel!
    @IBOutlet weak var totalFat: UILabel!
    @IBOutlet weak var totalPRotein: UILabel!
    @IBOutlet weak var totalCalori: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var purpleLabel: UILabel!
    @IBOutlet weak var greenV1: UIView!
    @IBOutlet weak var yellowV1: UIView!
    @IBOutlet weak var redV1: UIView!
    @IBOutlet weak var purpleV1: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var firstLook: UIView!
    //right of circle
    @IBOutlet weak var greenInfoLabel: UILabel!
    @IBOutlet weak var yellowInfoLabel: UILabel!
    @IBOutlet weak var redInfoLabel: UILabel!
    @IBOutlet weak var purpleInfoLabel: UILabel!
    @IBOutlet weak var greenTotal: UILabel!
    @IBOutlet weak var yellowTotal: UILabel!
    @IBOutlet weak var redTotal: UILabel!
    @IBOutlet weak var purpleTotal: UILabel!
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
        rotateLabel(purpleLabel, degrees: 45)
        rotateLabel(redLabel, degrees: -45)
        rotateLabel(yellowLabel, degrees: -45)
        rotateLabel(greenLabel, degrees: 45)
        
        rotateLabel(redTotal, degrees: 90)
        rotateLabel(greenTotal, degrees: 90)
        rotateLabel(yellowTotal, degrees: 90)
        rotateLabel(purpleTotal, degrees: 90)
    }
  
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
        // 1. Fetch foods for the selected date
        coredata.fetchBreakfast(forDate: sender.date)

        // 2. Update UI based on fetched data
        sumBreakfast(forDate: sender.date) // Assuming this function uses the fetched data
       
        updateLabel()
        ui.updateButtonTapped()

        // 3. Reload table view to reflect changes
        tableView.reloadData()
       
    }

    func rotateLabel(_ label: UILabel, degrees: CGFloat) {
        // Dereceyi radyana çevir
        let radians = degrees * .pi / 180
        
        // UILabel'ı belirtilen dereceyle döndür
        label.transform = CGAffineTransform(rotationAngle: -radians)
    }
    
    // UITabBarControllerDelegate metodunu implement et
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if viewController is HomeViewController {
                // start up
                coredata.fetchBreakfast(forDate: datePicker.date)
                fetchDataAndUpdateUI()
                ui.updateButtonTapped()
                tableView.reloadData()
            }
        }
    //start up reactions
    func startUpSetup() {
        ///print(coredata?.filePath ?? "Not Found")
        helper = Helper()
        coredata = Coredata()
        ui = Ui()
        setLayers()
        //Fetch items
        coredata = cafoll.Coredata()
        coredata.fetchBreakfast(forDate: datePicker.date)
        coredata.fetchLunch()
        coredata.fetchDinner()
        coredata.fetchSnack()
        ///coredata.fetchMaxValueCircle()
        fetchDataAndUpdateUI()
        updateLabel()
        //UI
        ui.uiTools(homeViewController: self)
        firstLook.bringSubviewToFront(settingsButton)
        firstLook.bringSubviewToFront(stackViewValues)
        //out of popup
        gestureView.frame = UIScreen.main.bounds
        gestureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.7, height: self.view.bounds.height * 0.3)
        // Add UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gestureView.addGestureRecognizer(tapGesture)
        //table View Load
        tabBarController?.delegate = self
        tableView.reloadData()
        // Textfield'ların değişikliklerini dinle
        textfieldCarbon.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldFat.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldProtein.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldCalori.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Butonu başlangıçta devre dışı bırak
        updateButton.isEnabled = false
    }
    func getDatePickerDate() -> Date? {
           return datePicker?.date
       }
    //view Shadows
    func setLayers() {
        [popupV1, popupV2, popupV3, popupV4].forEach { $0.layer.cornerRadius = 12 }
        [redV1, purpleV1, yellowV1, greenV1].forEach { $0.layer.cornerRadius = 5 }
        
        popupTitleV.layer.cornerRadius = 12
        popupTitleV.layer.shadowColor = UIColor.darkGray.cgColor
        popupTitleV.layer.shadowOffset = CGSize(width: 0, height: 3)
        popupTitleV.layer.shadowRadius = 3
        popupTitleV.layer.shadowOpacity = 0.2
       
    }
    func fetchDataAndUpdateUI() {
            switch segment.selectedSegmentIndex {
            case 0:
                coredata.fetchBreakfast(forDate: datePicker.date)
              
                sumBreakfast(forDate: datePicker.date)
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

    //popup in & out animation
    func animated(desiredView: UIView) {
        let backgroundView = self.view!

        popupView.layer.cornerRadius = 12
        popupView.layer.shadowColor = UIColor.darkGray.cgColor
        popupView.layer.shadowOffset = CGSize(width: 0, height: 6)
        popupView.layer.shadowRadius = 6
        popupView.layer.shadowOpacity = 0.2
        popupView.layer.masksToBounds = false
       

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
    
    @IBAction func popupButtonPressed(_ sender: UIButton) {
        updateLabel()
        // Animate the popupView
        animated(desiredView: gestureView)
        animated(desiredView: popupView)
    }

    func updateLabel() {
      
    }

    @IBAction func deleteAllFetchValues(_ sender: UIButton) {
        if let existingMaxValueCircles = self.coredata.maxValueCircle {
            for circle in existingMaxValueCircles {
                coredata.context.delete(circle)
                print("deleted all fetch Values")
            }
            print("After deletion. Count: \(existingMaxValueCircles.count)")
            coredata.saveData()
        }

    }
    //button in external view
    @IBAction func activeButtonPressed(_ sender: UIButton) {
        let coredataMaxValue = MaxValueCircle(context: self.coredata.context)
        coredataMaxValue.maxValueCalori = Float(textfieldCalori.text ?? "") ?? 0.0
        coredataMaxValue.maxValueProtein = Float(textfieldProtein.text ?? "") ?? 0.0
        coredataMaxValue.maxValueFat = Float(textfieldFat.text ?? "") ?? 0.0
        coredataMaxValue.maxValueCarbon = Float(textfieldCarbon.text ?? "") ?? 0.0
        
        updateLabel()
        ui.updateButtonTapped()
        print(coredataMaxValue)
        
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
                tableView.reloadData()
                coredata.fetchBreakfast(forDate: datePicker.date)
                fetchDataAndUpdateUI()
                ui.updateButtonTapped()
                sumBreakfast(forDate: datePicker.date)
            case 1:
                tableView.reloadData()
                coredata.fetchLunch()
                fetchDataAndUpdateUI()
                ui.updateButtonTapped()
                sumLunch()
            case 2:
                tableView.reloadData()
                coredata.fetchDinner()
                fetchDataAndUpdateUI()
                ui.updateButtonTapped()
                sumDinner()
            case 3:
                tableView.reloadData()
                coredata.fetchSnack()
                fetchDataAndUpdateUI()
                ui.updateButtonTapped()
                sumSnack()
            default:
                break
            }
            // Update the table
            tableView.reloadData()
        }
        
    func sumBreakfast(forDate date: Date) {
        guard let breakfastItems = self.coredata.breakfast else {
            return
        }

        // Calculate the sum of values for calories, fat, protein, and carbohydrates for the given date
        var totalCalories = 0.0
        var totalFats = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in breakfastItems {
            // Eğer öğünün tarihi, istediğiniz tarih ile aynıysa, değerleri topla
            if let itemDate = item.date, Calendar.current.isDate(itemDate, inSameDayAs: date) {
                totalCalories += Double(item.calori ?? "0") ?? 0.0
                totalFats += Double(item.fat ?? "0") ?? 0.0
                totalProtein += Double(item.protein ?? "0") ?? 0.0
                totalCarbs += Double(item.carbon ?? "0") ?? 0.0
            }
        }

        // Update the progress views and labels with the calculated totals
        let maxGreen: Float = 20
        let maxYellow: Float = 25
        let maxRed: Float = 30
        let maxPurple: Float = 700

        updateProgressViews(calories: totalCalories, fat: totalFats, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)

        // Diğer UI elemanlarını güncelle
        // ...

        // Toplam değerleri ekrana yazdır
        purpleInfoLabel.text = String(format: "%.0f", totalCalories)
        redInfoLabel.text = String(format: "%.0f", totalProtein)
        yellowInfoLabel.text = String(format: "%.0f", totalFats)
        greenInfoLabel.text = String(format: "%.0f", totalCarbs)

        purpleTotal.text = String(format: "%.0f", maxPurple)
        redTotal.text = String(format: "%.0f", maxRed)
        yellowTotal.text = String(format: "%.0f", maxYellow)
        greenTotal.text = String(format: "%.0f", maxGreen)

        totalCalori.text = String(format: "%.0f", totalCalories)
        totalPRotein.text = String(format: "%.0f", totalProtein)
        totalFat.text = String(format: "%.0f", totalFats)
        totalCarbon.text = String(format: "%.0f", totalCarbs)
    }

    func sumLunch() {
        guard let lunchItems = self.coredata.lunch else {
            return
        }

        // Calculate the sum of values for calories, fat, protein, and carbohydrates
        var totalCalories = 0.0
        var totalFats = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in lunchItems {
            totalCalories += Double(item.calori!) ?? 0.0
            totalFats += Double(item.fat!) ?? 0.0
            totalProtein += Double(item.protein!) ?? 0.0
            totalCarbs += Double(item.carbon!) ?? 0.0 // Assuming "carbon" is the property representing carbohydrates
        }

        // Update the progress views with specific maximum values for lunch
        let maxGreen: Float = 20
        let maxYellow: Float = 25
        let maxRed: Float = 30
        let maxPurple: Float = 700

        updateProgressViews(calories: totalCalories, fat: totalFats, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)
        
        purpleInfoLabel.text = String(format: "%.0f", totalCalories)
        redInfoLabel.text = String(format: "%.0f", totalProtein)
        yellowInfoLabel.text = String(format: "%.0f", totalFats)
        greenInfoLabel.text = String(format: "%.0f", totalCarbs)
        
        purpleTotal.text = String(format: "%.0f", maxPurple)
         redTotal.text = String(format: "%.0f", maxRed)
         yellowTotal.text = String(format: "%.0f", maxYellow)
         greenTotal.text = String(format: "%.0f", maxGreen)
    }

    func sumDinner() {
        guard let dinnerItems = self.coredata.dinner else {
            return
        }

        // Calculate the sum of values for calories, fat, protein, and carbohydrates
        var totalCalories = 0.0
        var totalFats = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in dinnerItems {
            totalCalories += Double(item.calori!) ?? 0.0
            totalFats += Double(item.fat!) ?? 0.0
            totalProtein += Double(item.protein!) ?? 0.0
            totalCarbs += Double(item.carbon!) ?? 0.0 // Assuming "carbon" is the property representing carbohydrates
        }

        // Update the progress views with specific maximum values for dinner
        let maxGreen: Float = 20
        let maxYellow: Float = 25
        let maxRed: Float = 30
        let maxPurple: Float = 700

        updateProgressViews(calories: totalCalories, fat: totalFats, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)
        
        purpleInfoLabel.text = String(format: "%.0f", totalCalories)
        redInfoLabel.text = String(format: "%.0f", totalProtein)
        yellowInfoLabel.text = String(format: "%.0f", totalFats)
        greenInfoLabel.text = String(format: "%.0f", totalCarbs)
        
        purpleTotal.text = String(format: "%.0f", maxPurple)
         redTotal.text = String(format: "%.0f", maxRed)
         yellowTotal.text = String(format: "%.0f", maxYellow)
         greenTotal.text = String(format: "%.0f", maxGreen)
    }

    func sumSnack() {
        guard let snackItems = self.coredata.snack else {
            return
        }

        // Calculate the sum of values for calories, fat, protein, and carbohydrates
        var totalCalories = 0.0
        var totalFats = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in snackItems {
            totalCalories += Double(item.calori!) ?? 0.0
            totalFats += Double(item.fat!) ?? 0.0
            totalProtein += Double(item.protein!) ?? 0.0
            totalCarbs += Double(item.carbon!) ?? 0.0 // Assuming "carbon" is the property representing carbohydrates
        }

        // Update the progress views with specific maximum values for snack
        let maxGreen: Float = 20
        let maxYellow: Float = 25
        let maxRed: Float = 30
        let maxPurple: Float = 700

        updateProgressViews(calories: totalCalories, fat: totalFats, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)
        
        purpleInfoLabel.text = String(format: "%.0f", totalCalories)
        redInfoLabel.text = String(format: "%.0f", totalProtein)
        yellowInfoLabel.text = String(format: "%.0f", totalFats)
        greenInfoLabel.text = String(format: "%.0f", totalCarbs)
        
        purpleTotal.text = String(format: "%.0f", maxPurple)
         redTotal.text = String(format: "%.0f", maxRed)
         yellowTotal.text = String(format: "%.0f", maxYellow)
         greenTotal.text = String(format: "%.0f", maxGreen)
    }
    
    func sumAllMeals() {

    }

    func updateProgressViews(calories: Double, fat: Double, protein: Double, carbs: Double, maxGreen: Float, maxYellow: Float, maxRed: Float, maxPurple: Float) {
        // Update progress views based on the calculated sum for each nutrient
        progressPurple.progress = min(Float(calories) / maxPurple, 1.0)
        progressYellow.progress = min(Float(fat) / maxYellow, 1.0)
        progressRed.progress = min(Float(protein) / maxRed, 1.0)
        progressGreen.progress = min(Float(carbs) / maxGreen, 1.0)
    }

    // Helper function to determine the highest value and return the corresponding color
    func determineHighestValueColor(calori: Double, fat: Double, protein: Double, carbon: Double) -> UIColor {
        var highestValueColor: UIColor = .clear

        let maxValue = max(calori, fat, protein, carbon)

        if maxValue == calori {
            highestValueColor = .systemIndigo
        } else if maxValue == fat {
            highestValueColor = .systemYellow
        } else if maxValue == protein {
            highestValueColor = .systemRed
        } else if maxValue == carbon {
            highestValueColor = .systemGreen
        }


        return highestValueColor
    }
}
// MARK: - Home Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segment.selectedSegmentIndex {
        case 0:
           
            return self.coredata.breakfast?.count ?? 0
        case 1:
            
            return self.coredata.lunch?.count ?? 0
        case 2:
            
            return self.coredata.dinner?.count ?? 0
        case 3:
      
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
                highestValueColor = determineHighestValueColor(carbons: indexBreakfast.carbon ?? "0", fat: indexBreakfast.fat ?? "0", protein: indexBreakfast.protein ?? "0")
            }
        case 1:
            if let indexLunch = self.coredata.lunch?[row] {
                cell.titleLabel?.text = indexLunch.title
                highestValueColor = determineHighestValueColor(carbons: indexLunch.carbon ?? "0", fat: indexLunch.fat ?? "0", protein: indexLunch.protein ?? "0")
            }
        case 2:
            if let indexDinner = self.coredata.dinner?[row] {
                cell.titleLabel?.text = indexDinner.title
                highestValueColor = determineHighestValueColor(carbons: indexDinner.carbon ?? "0", fat: indexDinner.fat ?? "0", protein: indexDinner.protein ?? "0")
            }
        case 3:
            if let indexSnack = self.coredata.snack?[row] {
                cell.titleLabel?.text = indexSnack.title
                highestValueColor = determineHighestValueColor(carbons: indexSnack.carbon ?? "0", fat: indexSnack.fat ?? "0", protein: indexSnack.protein ?? "0")
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
                sumBreakfast(forDate: datePicker.date)
                ui.updateButtonTapped()
            }
        case 1:
            if let lunchItem = self.coredata.lunch?[indexPath.row] {
                context.delete(lunchItem)
                self.coredata.lunch?.remove(at: indexPath.row)
                sumLunch() // Öğün türüne özel sum fonksiyonunu çağır
                ui.updateButtonTapped()
            }
        case 2:
            if let dinnerItem = self.coredata.dinner?[indexPath.row] {
                context.delete(dinnerItem)
                self.coredata.dinner?.remove(at: indexPath.row)
                sumDinner() // Öğün türüne özel sum fonksiyonunu çağır
                ui.updateButtonTapped()
            }
        case 3:
            if let snackItem = self.coredata.snack?[indexPath.row] {
                context.delete(snackItem)
                self.coredata.snack?.remove(at: indexPath.row)
                sumSnack() // Öğün türüne özel sum fonksiyonunu çağır
                ui.updateButtonTapped()
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

