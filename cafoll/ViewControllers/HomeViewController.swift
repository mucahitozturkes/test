//
//  HomeViewController.swift
//  cafoll
//
//  Created by mücahit öztürk on 4.12.2023.
//

import UIKit

class HomeViewController: UIViewController,UITabBarControllerDelegate {

    //Header
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateView: UIView!
    //circle
    @IBOutlet weak var goalTextLAbel: UILabel!
    @IBOutlet weak var checkMarkMaxValue: UIImageView!
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
    @IBOutlet weak var firstLook: UIView!
    //right of circle
    @IBOutlet weak var markGreen: UIImageView!
    @IBOutlet weak var markYellow: UIImageView!
    @IBOutlet weak var markRed: UIImageView!
    @IBOutlet weak var markPurple: UIImageView!
    @IBOutlet weak var nameOfMeals: UILabel!
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
    }
  
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
        // 1. Fetch foods for the selected date
        coredata.fetchBreakfast(forDate: sender.date)
        coredata.fetchLunch(forDate: sender.date)
        coredata.fetchDinner(forDate: sender.date)
        coredata.fetchSnack(forDate: sender.date)
     
        

        // 2. Update UI based on fetched data
        sumBreakfast(forDate: sender.date) // Assuming this function uses the fetched data
        sumLunch(forDate: sender.date)
        sumDinner(forDate: sender.date)
        sumSnack(forDate: sender.date)
        
        // 3. set updated
        updateLabel()
        ui.updateButtonTapped()
        fetchDataAndUpdateUI()
        // 4. Reload table view to reflect changes
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
                coredata.fetchLunch(forDate: datePicker.date)
                coredata.fetchDinner(forDate: datePicker.date)
                coredata.fetchSnack(forDate: datePicker.date)
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
        coredata.fetchLunch(forDate: datePicker.date)
        coredata.fetchDinner(forDate: datePicker.date)
        coredata.fetchSnack(forDate: datePicker.date)
        fetchDataAndUpdateUI()
        updateLabel()
     
        //UI
        ui.uiTools(homeViewController: self)
        firstLook.bringSubviewToFront(stackViewValues)
        //table View Load
        tabBarController?.delegate = self
        tableView.reloadData()
      
    }
    func getDatePickerDate() -> Date? {
           return datePicker?.date
       }
    //view Shadows
    func setLayers() {
        [redV1, purpleV1, yellowV1, greenV1].forEach { $0.layer.cornerRadius = 5 }
    }
    func fetchDataAndUpdateUI() {
            switch segment.selectedSegmentIndex {
            case 0:
                coredata.fetchBreakfast(forDate: datePicker.date)
                sumBreakfast(forDate: datePicker.date)
                nameOfMeals.text = "Breakfast"
            case 1:
                coredata.fetchLunch(forDate: datePicker.date)
                sumLunch(forDate: datePicker.date)
                nameOfMeals.text = "Lunch"
            case 2:
                coredata.fetchDinner(forDate: datePicker.date)
                sumDinner(forDate: datePicker.date)
                nameOfMeals.text = "Dinner"
            case 3:
                coredata.fetchSnack(forDate: datePicker.date)
                sumSnack(forDate: datePicker.date)
                nameOfMeals.text = "Snack"
            default:
                break
            }
            
            // Update the table
            tableView.reloadData()
        }
   
    func updateLabel() {
        nameOfMeals.text = "Breakfast"
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
                nameOfMeals.text = "Breakfast"
             
            case 1:
                tableView.reloadData()
                coredata.fetchLunch(forDate: datePicker.date)
                fetchDataAndUpdateUI()
                ui.updateButtonTapped()
                sumLunch(forDate: datePicker.date)
                nameOfMeals.text = "Lunch"
              
            case 2:
                tableView.reloadData()
                coredata.fetchDinner(forDate: datePicker.date)
                fetchDataAndUpdateUI()
                ui.updateButtonTapped()
                sumDinner(forDate: datePicker.date)
                nameOfMeals.text = "Dinner"
            
            case 3:
                tableView.reloadData()
                coredata.fetchSnack(forDate: datePicker.date)
                fetchDataAndUpdateUI()
                ui.updateButtonTapped()
                sumSnack(forDate: datePicker.date)
                nameOfMeals.text = "Snack"
              
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
        let maxGreen: Float = 25
        let maxYellow: Float = 25
        let maxRed: Float = 25
        let maxPurple: Float = 700

        updateProgressViews(calories: totalCalories, fat: totalFats, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)
   
        // Toplam değerleri ekrana yazdır
        purpleInfoLabel.text = String(format: "%.0f", totalCalories)
        redInfoLabel.text = String(format: "%.0f", totalProtein)
        yellowInfoLabel.text = String(format: "%.0f", totalFats)
        greenInfoLabel.text = String(format: "%.0f", totalCarbs)

        purpleTotal.text = String(format: "%.0f", maxPurple)
        redTotal.text = String(format: "%.0f", maxRed)
        yellowTotal.text = String(format: "%.0f", maxYellow)
        greenTotal.text = String(format: "%.0f", maxGreen)
        
        updateVisibility(markPurple, value: totalCalories, threshold: Double(maxPurple))
        updateVisibility(markRed, value: totalProtein, threshold: Double(maxRed))
        updateVisibility(markYellow, value: totalFats, threshold: Double(maxYellow))
        updateVisibility(markGreen, value: totalCarbs, threshold: Double(maxGreen))
    }

    func sumLunch(forDate date: Date) {
        guard let lunchItems = self.coredata.lunch else {
            return
        }
        
       
        // Calculate the sum of values for calories, fat, protein, and carbohydrates for the given date
        var totalCalories = 0.0
        var totalFats = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in lunchItems {
            // Eğer öğünün tarihi, istediğiniz tarih ile aynıysa, değerleri topla
            if let itemDate = item.date, Calendar.current.isDate(itemDate, inSameDayAs: date) {
                totalCalories += Double(item.calori ?? "0") ?? 0.0
                totalFats += Double(item.fat ?? "0") ?? 0.0
                totalProtein += Double(item.protein ?? "0") ?? 0.0
                totalCarbs += Double(item.carbon ?? "0") ?? 0.0
            }
        }
      
        // Update the progress views and labels with the calculated totals
        let maxGreen: Float = 25
        let maxYellow: Float = 25
        let maxRed: Float = 25
        let maxPurple: Float = 700

     
        updateProgressViews(calories: totalCalories, fat: totalFats, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)

     
        // Toplam değerleri ekrana yazdır
        purpleInfoLabel.text = String(format: "%.0f", totalCalories)
        redInfoLabel.text = String(format: "%.0f", totalProtein)
        yellowInfoLabel.text = String(format: "%.0f", totalFats)
        greenInfoLabel.text = String(format: "%.0f", totalCarbs)

        purpleTotal.text = String(format: "%.0f", maxPurple)
        redTotal.text = String(format: "%.0f", maxRed)
        yellowTotal.text = String(format: "%.0f", maxYellow)
        greenTotal.text = String(format: "%.0f", maxGreen)
        
        updateVisibility(markPurple, value: totalCalories, threshold: Double(maxPurple))
        updateVisibility(markRed, value: totalProtein, threshold: Double(maxRed))
        updateVisibility(markYellow, value: totalFats, threshold: Double(maxYellow))
        updateVisibility(markGreen, value: totalCarbs, threshold: Double(maxGreen))
    }

    func sumDinner(forDate date: Date) {
        guard let dinnerItems = self.coredata.dinner else {
            return
        } 
    
        // Calculate the sum of values for calories, fat, protein, and carbohydrates for the given date
        var totalCalories = 0.0
        var totalFats = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in dinnerItems {
            // Eğer öğünün tarihi, istediğiniz tarih ile aynıysa, değerleri topla
            if let itemDate = item.date, Calendar.current.isDate(itemDate, inSameDayAs: date) {
                totalCalories += Double(item.calori ?? "0") ?? 0.0
                totalFats += Double(item.fat ?? "0") ?? 0.0
                totalProtein += Double(item.protein ?? "0") ?? 0.0
                totalCarbs += Double(item.carbon ?? "0") ?? 0.0
            }
        }
     
        // Update the progress views and labels with the calculated totals
        let maxGreen: Float = 25
        let maxYellow: Float = 25
        let maxRed: Float = 25
        let maxPurple: Float = 700

     
        updateProgressViews(calories: totalCalories, fat: totalFats, protein: totalProtein, carbs: totalCarbs, maxGreen: maxGreen, maxYellow: maxYellow, maxRed: maxRed, maxPurple: maxPurple)

        // Toplam değerleri ekrana yazdır
        purpleInfoLabel.text = String(format: "%.0f", totalCalories)
        redInfoLabel.text = String(format: "%.0f", totalProtein)
        yellowInfoLabel.text = String(format: "%.0f", totalFats)
        greenInfoLabel.text = String(format: "%.0f", totalCarbs)

        purpleTotal.text = String(format: "%.0f", maxPurple)
        redTotal.text = String(format: "%.0f", maxRed)
        yellowTotal.text = String(format: "%.0f", maxYellow)
        greenTotal.text = String(format: "%.0f", maxGreen)
        
        updateVisibility(markPurple, value: totalCalories, threshold: Double(maxPurple))
        updateVisibility(markRed, value: totalProtein, threshold: Double(maxRed))
        updateVisibility(markYellow, value: totalFats, threshold: Double(maxYellow))
        updateVisibility(markGreen, value: totalCarbs, threshold: Double(maxGreen))
    }

    func sumSnack(forDate date: Date) {
        guard let snackItems = self.coredata.snack else {
            return
        }
 
        // Calculate the sum of values for calories, fat, protein, and carbohydrates for the given date
        var totalCalories = 0.0
        var totalFats = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0

        for item in snackItems {
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

        // Toplam değerleri ekrana yazdır
        purpleInfoLabel.text = String(format: "%.0f", totalCalories)
        redInfoLabel.text = String(format: "%.0f", totalProtein)
        yellowInfoLabel.text = String(format: "%.0f", totalFats)
        greenInfoLabel.text = String(format: "%.0f", totalCarbs)

        purpleTotal.text = String(format: "%.0f", maxPurple)
        redTotal.text = String(format: "%.0f", maxRed)
        yellowTotal.text = String(format: "%.0f", maxYellow)
        greenTotal.text = String(format: "%.0f", maxGreen)
        
        updateVisibility(markPurple, value: totalCalories, threshold: Double(maxPurple))
        updateVisibility(markRed, value: totalProtein, threshold: Double(maxRed))
        updateVisibility(markYellow, value: totalFats, threshold: Double(maxYellow))
        updateVisibility(markGreen, value: totalCarbs, threshold: Double(maxGreen))
    }
    
    func updateVisibility(_ mark: UIImageView, value: Double, threshold: Double) {
        mark.isHidden = value < threshold
    
    }

    func updateProgressViews(calories: Double, fat: Double, protein: Double, carbs: Double, maxGreen: Float, maxYellow: Float, maxRed: Float, maxPurple: Float) {
        // Update progress views based on the calculated sum for each nutrient
        progressPurple.progress = min(Float(calories) / maxPurple, 1.0)
        progressYellow.progress = min(Float(fat) / maxYellow, 1.0)
        progressRed.progress = min(Float(protein) / maxRed, 1.0)
        progressGreen.progress = min(Float(carbs) / maxGreen, 1.0)
        
        sumMeals(forDate: datePicker.date)
    }
    
    func sumMeals(forDate date: Date) {
        var totalCalories = 0.0
        var totalFats = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0
        guard let breakfastItems = self.coredata.breakfast else {
            return
        }

        for item in breakfastItems {
            // Eğer öğünün tarihi, istediğiniz tarih ile aynıysa, değerleri topla
            if let itemDate = item.date, Calendar.current.isDate(itemDate, inSameDayAs: date) {
                totalCalories += Double(item.calori ?? "0") ?? 0.0
                totalFats += Double(item.fat ?? "0") ?? 0.0
                totalProtein += Double(item.protein ?? "0") ?? 0.0
                totalCarbs += Double(item.carbon ?? "0") ?? 0.0
            }
        }
        guard let lunchItems = self.coredata.lunch else {
            return
        }
    
        for item in lunchItems {
            // Eğer öğünün tarihi, istediğiniz tarih ile aynıysa, değerleri topla
            if let itemDate = item.date, Calendar.current.isDate(itemDate, inSameDayAs: date) {
                totalCalories += Double(item.calori ?? "0") ?? 0.0
                totalFats += Double(item.fat ?? "0") ?? 0.0
                totalProtein += Double(item.protein ?? "0") ?? 0.0
                totalCarbs += Double(item.carbon ?? "0") ?? 0.0
            }
        }
        guard let dinnerItems = self.coredata.dinner else {
            return
        }

        for item in dinnerItems {
            // Eğer öğünün tarihi, istediğiniz tarih ile aynıysa, değerleri topla
            if let itemDate = item.date, Calendar.current.isDate(itemDate, inSameDayAs: date) {
                totalCalories += Double(item.calori ?? "0") ?? 0.0
                totalFats += Double(item.fat ?? "0") ?? 0.0
                totalProtein += Double(item.protein ?? "0") ?? 0.0
                totalCarbs += Double(item.carbon ?? "0") ?? 0.0
            }
        }
        
        guard let snackItems = self.coredata.snack else {
            return
        }
        for item in snackItems {
            // Eğer öğünün tarihi, istediğiniz tarih ile aynıysa, değerleri topla
            if let itemDate = item.date, Calendar.current.isDate(itemDate, inSameDayAs: date) {
                totalCalories += Double(item.calori ?? "0") ?? 0.0
                totalFats += Double(item.fat ?? "0") ?? 0.0
                totalProtein += Double(item.protein ?? "0") ?? 0.0
                totalCarbs += Double(item.carbon ?? "0") ?? 0.0
            }
        }
        
        totalCalori.text = String(format: "%.0f", totalCalories)
        totalPRotein.text = String(format: "%.0f", totalProtein)
        totalFat.text = String(format: "%.0f", totalFats)
        totalCarbon.text = String(format: "%.0f", totalCarbs)
        
        if totalCalories >= Double(ui.caloriValue),
           totalProtein >= Double(ui.proteinValue),
           totalFats >= Double(ui.fatValue),
           totalCarbs >= Double(ui.carbonValue)
        {
            checkMarkMaxValue.isHidden = false
            goalTextLAbel.isHidden = true
        } else {
            checkMarkMaxValue.isHidden = true
            goalTextLAbel.isHidden = false
        }
    }
    
    // Sağa tıklandığında tarihi bir gün ileri al
        @IBAction func rightDate(_ sender: UIButton) {
            var currentDate = datePicker.date
                // Bir gün ekleyerek tarihi güncelle
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                datePicker.setDate(currentDate, animated: true)
            fetchDataAndUpdateUI()
            coredata.fetchBreakfast(forDate: datePicker.date)
            coredata.fetchLunch(forDate: datePicker.date)
            coredata.fetchDinner(forDate: datePicker.date)
            coredata.fetchSnack(forDate: datePicker.date)
            // 2. Update UI based on fetched data
            sumBreakfast(forDate: datePicker.date) // Assuming this function uses the fetched data
            sumLunch(forDate: datePicker.date)
            sumDinner(forDate: datePicker.date)
            sumSnack(forDate: datePicker.date)
            // 3. set updated
            updateLabel()
            ui.updateButtonTapped()
            fetchDataAndUpdateUI()
            // 4. Reload table view to reflect changes
            tableView.reloadData()
        }

        // Sola tıklandığında tarihi bir gün geri al
        @IBAction func leftDate(_ sender: UIButton) {
            var currentDate = datePicker.date
                // Bir gün çıkartarak tarihi güncelle
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
                datePicker.setDate(currentDate, animated: true)
            fetchDataAndUpdateUI()
            coredata.fetchBreakfast(forDate: datePicker.date)
            coredata.fetchLunch(forDate: datePicker.date)
            coredata.fetchDinner(forDate: datePicker.date)
            coredata.fetchSnack(forDate: datePicker.date)
            // 2. Update UI based on fetched data
            sumBreakfast(forDate: datePicker.date) // Assuming this function uses the fetched data
            sumLunch(forDate: datePicker.date)
            sumDinner(forDate: datePicker.date)
            sumSnack(forDate: datePicker.date)
            // 3. set updated
            updateLabel()
            ui.updateButtonTapped()
            fetchDataAndUpdateUI()
            // 4. Reload table view to reflect changes
            tableView.reloadData()
            
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
        if let carbsValue = Double(carbons), let fatValue = Double(fat), let proteinValue = Double(protein) {
            let maxValue = max(carbsValue, fatValue, proteinValue)
            
            if maxValue == carbsValue {
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
                sumLunch(forDate: datePicker.date) // Öğün türüne özel sum fonksiyonunu çağır
                ui.updateButtonTapped()
            }
        case 2:
            if let dinnerItem = self.coredata.dinner?[indexPath.row] {
                context.delete(dinnerItem)
                self.coredata.dinner?.remove(at: indexPath.row)
                sumDinner(forDate: datePicker.date) // Öğün türüne özel sum fonksiyonunu çağır
                ui.updateButtonTapped()
            }
        case 3:
            if let snackItem = self.coredata.snack?[indexPath.row] {
                context.delete(snackItem)
                self.coredata.snack?.remove(at: indexPath.row)
                sumSnack(forDate: datePicker.date) // Öğün türüne özel sum fonksiyonunu çağır
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

