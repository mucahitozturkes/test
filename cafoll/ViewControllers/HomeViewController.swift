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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var datePicker: UIButton!
    @IBOutlet weak var dateView: UIView!
   
    @IBOutlet weak var secondLook: UIView!
    
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var popupTitleV: UIView!
    @IBOutlet weak var popupV4: UIView!
    @IBOutlet weak var popupV3: UIView!
    @IBOutlet weak var popupV2: UIView!
    @IBOutlet weak var popupV1: UIView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var firstLook: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var coredata: Coredata!
    var helper: Helper!
    var ui: Ui!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      startUpSetup()
    }
    
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
    
    //view Shadows
    func setLayers() {
        [popupV1, popupV2, popupV3, popupV4].forEach { $0.layer.cornerRadius = 12 }
        
        popupTitleV.layer.cornerRadius = 12
        popupTitleV.layer.shadowColor = UIColor.lightGray.cgColor
        popupTitleV.layer.shadowOffset = CGSize(width: 0, height: 6)
        popupTitleV.layer.shadowRadius = 8
        popupTitleV.layer.shadowOpacity = 0.1
        
        
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        animatedOut(desiredView: popupView)
        animatedOut(desiredView: gestureView)
    }
    
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
    
    @IBAction func activeButtonPressed(_ sender: UIButton) {
        ui.updateButtonTapped()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Textfield'ların değerlerini kontrol et ve butonu aktif hale getir veya devre dışı bırak
        let isAllFieldsFilled = !(textfieldCarbon.text?.isEmpty ?? true) &&
                                !(textfieldFat.text?.isEmpty ?? true) &&
                                !(textfieldProtein.text?.isEmpty ?? true) &&
                                !(textfieldCalori.text?.isEmpty ?? true)

        updateButton.isEnabled = isAllFieldsFilled
       
    }
}
// MARK: - Home Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        //let row = indexPath.row
        
        cell.textLabel?.text = "hello!"
        
        return cell
    }
}
