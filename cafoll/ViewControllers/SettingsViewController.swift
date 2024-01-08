//
//  SettingsViewController.swift
//  cafoll
//
//  Created by mücahit öztürk on 5.01.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
  
    //circle Value
    @IBOutlet weak var circleGreen: UILabel!
    @IBOutlet weak var circleRed: UILabel!
    @IBOutlet weak var circleYellow: UILabel!
    @IBOutlet weak var circlePurple: UILabel!
    //progress Name
    @IBOutlet weak var progressName: UILabel!
    //right progress Value
    @IBOutlet weak var progressGreen: UILabel!
    @IBOutlet weak var progressYellow: UILabel!
    @IBOutlet weak var progressRed: UILabel!
    @IBOutlet weak var progressPurple: UILabel!
    //sliders Value
    @IBOutlet weak var sliderValueGreen: UILabel!
    @IBOutlet weak var sliderValueYellow: UILabel!
    @IBOutlet weak var sliderValueRed: UILabel!
    @IBOutlet weak var sliderValuePurple: UILabel!
    //sliders
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderYellow: UISlider!
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderPurple: UISlider!
    //Views
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var circileView: UIView!
    @IBOutlet weak var FirstViewLayer: UIView!
    
    var ui: Ui!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
           super.viewDidLoad()
           ui = Ui()
           ui.applyShadow(to: FirstViewLayer, offset: CGSize(width: 0, height: 6), radius: 12)
           ui.applyShadow(to: circileView, offset: CGSize(width: 0, height: 6), radius: 12)
           ui.applyShadow(to: rightView, offset: CGSize(width: 0, height: 6), radius: 12)
      
            loadDefaults()
               // Slider değerlerini güncelle
            updateSliderValues()
        
       }
       
    @IBAction func sliderValueChanged(_ sender: UISlider) {
           updateSliderValues()
           saveSliderValues()
       }
    func updateSliderValues() {
        sliderValueGreen.text = String(format: "%.0f", sliderGreen.value)
        sliderValueYellow.text = String(format: "%.0f", sliderYellow.value)
        sliderValueRed.text = String(format: "%.0f", sliderRed.value)
        sliderValuePurple.text = String(format: "%.0f", sliderPurple.value)
        
        progressGreen.text = sliderValueGreen.text
        progressYellow.text = sliderValueYellow.text
        progressRed.text = sliderValueRed.text
        progressPurple.text = sliderValuePurple.text
    }


       func saveSliderValues() {
           userDefaults.set(sliderGreen.value, forKey: "greenSliderValue")
           userDefaults.set(sliderYellow.value, forKey: "yellowSliderValue")
           userDefaults.set(sliderRed.value, forKey: "redSliderValue")
           userDefaults.set(sliderPurple.value, forKey: "purpleSliderValue")
       }
    func loadDefaults() {
        if let savedGreenValue = userDefaults.value(forKey: "greenSliderValue") as? Float {
            sliderGreen.value = savedGreenValue
            sliderValueGreen.text = String(format: "%.2f", savedGreenValue)
        }

        if let savedYellowValue = userDefaults.value(forKey: "yellowSliderValue") as? Float {
            sliderYellow.value = savedYellowValue
            sliderValueYellow.text = String(format: "%.2f", savedYellowValue)
        }

        if let savedRedValue = userDefaults.value(forKey: "redSliderValue") as? Float {
            sliderRed.value = savedRedValue
            sliderValueRed.text = String(format: "%.2f", savedRedValue)
        }

        if let savedPurpleValue = userDefaults.value(forKey: "purpleSliderValue") as? Float {
            sliderPurple.value = savedPurpleValue
            sliderValuePurple.text = String(format: "%.2f", savedPurpleValue)
        }
    }
    
   }
