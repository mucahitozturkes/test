//
//  SettingsViewController.swift
//  cafoll
//
//  Created by mücahit öztürk on 5.01.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var purpleTextfield: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
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
        addLongPressGesture(to: sliderGreen)
        addLongPressGesture(to: sliderYellow)
        addLongPressGesture(to: sliderRed)
        addLongPressGesture(to: sliderPurple)
        ui = Ui()
        ui.applyShadow(to: FirstViewLayer, offset: CGSize(width: 0, height: 6), radius: 12)
        ui.applyShadow(to: circileView, offset: CGSize(width: 0, height: 6), radius: 12)
        ui.applyShadow(to: rightView, offset: CGSize(width: 0, height: 6), radius: 12)
        circleTotal()
        loadSavedSliderValues()
        loadSavedSliderMaxValues()
        let initialSegment = segmentedControl.selectedSegmentIndex
        loadDefaults(forSegment: initialSegment)  // Yüklenen defaults, başlangıç segmenti için yapılıyor
        updateSliderValues()
        progressName.text = segmentName(forIndex: initialSegment)
       
    }
    
    func addLongPressGesture(to slider: UISlider) {
          let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
          slider.addGestureRecognizer(longPressGesture)
      }

      @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
          guard let slider = gesture.view as? UISlider else { return }

          if gesture.state == .began {
              // Basılı tutma işlemi başladığında alert göster
              showSliderMaxValueAlert(for: slider)
          }
      }

      func showSliderMaxValueAlert(for slider: UISlider) {
          let alert = UIAlertController(title: "Lütfen bir değer gir", message: "", preferredStyle: .alert)

          alert.addTextField { textField in
              textField.keyboardType = .numberPad
              textField.placeholder = "En yüksek değer"
          }

          let setAction = UIAlertAction(title: "Uygula", style: .default) { [weak self] _ in
              if let textField = alert.textFields?.first, let text = textField.text, let newValue = Float(text) {
                  // Yeni max değeri slider'a uygula
                  slider.maximumValue = newValue
                  // Yeni değeri UserDefaults'a kaydet
                  self?.saveSliderMaxValue(for: slider, value: newValue)
              }
          }

          let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

          alert.addAction(setAction)
          alert.addAction(cancelAction)

          present(alert, animated: true, completion: nil)
      }

      func saveSliderMaxValue(for slider: UISlider, value: Float) {
          let key = sliderMaxValueKey(for: slider)
          userDefaults.set(value, forKey: key)
      }

      func savedSliderMaxValue(for slider: UISlider) -> Float {
          let key = sliderMaxValueKey(for: slider)
          return userDefaults.float(forKey: key)
      }

      func sliderMaxValueKey(for slider: UISlider) -> String {
          return "Slider_\(slider.tag)_MaxValue"
      }

      func saveSliderValue(for slider: UISlider, value: Float) {
          let key = sliderValueKey(for: slider)
          userDefaults.set(value, forKey: key)
      }

      func savedSliderValue(for slider: UISlider) -> Float {
          let key = sliderValueKey(for: slider)
          return userDefaults.float(forKey: key)
      }

      func sliderValueKey(for slider: UISlider) -> String {
          return "Slider_\(slider.tag)_Value"
      }

      func loadSavedSliderValues() {
          sliderGreen.value = savedSliderValue(for: sliderGreen)
          sliderYellow.value = savedSliderValue(for: sliderYellow)
          sliderRed.value = savedSliderValue(for: sliderRed)
          sliderPurple.value = savedSliderValue(for: sliderPurple)
      }

      func loadSavedSliderMaxValues() {
          sliderGreen.maximumValue = savedSliderMaxValue(for: sliderGreen)
          sliderYellow.maximumValue = savedSliderMaxValue(for: sliderYellow)
          sliderRed.maximumValue = savedSliderMaxValue(for: sliderRed)
          sliderPurple.maximumValue = savedSliderMaxValue(for: sliderPurple)
      }
    
    @IBAction func segmentedControlPanel(_ sender: UISegmentedControl) {
        let segment = segmentedControl.selectedSegmentIndex
        progressName.text = segmentName(forIndex: segment)
        loadDefaults(forSegment: segment)
        updateSliderValues()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if sender == sliderGreen {
            updateLabelWithVibration(label: sliderValueGreen, value: sender.value, scaleX: 1.04, scaleY: 1.04)
            updateLabelWithVibration(label: progressGreen, value: sender.value, scaleX: 1.02, scaleY: 1.02)
            let greenUserDefaultsKey = "breakfastgreenSliderValue"
            if let savedGreenValue = UserDefaults.standard.value(forKey: greenUserDefaultsKey) as? Float {
                updateLabelWithVibration(label: circleGreen, value: savedGreenValue, scaleX: 1.04, scaleY: 1.04)
            }
        } else if sender == sliderYellow {
            updateLabelWithVibration(label: sliderValueYellow, value: sender.value, scaleX: 1.04, scaleY: 1.04)
            updateLabelWithVibration(label: progressYellow, value: sender.value, scaleX: 1.02, scaleY: 1.02)
            let yellowUserDefaultsKey = "breakfastyellowSliderValue"
            if let savedYellowValue = UserDefaults.standard.value(forKey: yellowUserDefaultsKey) as? Float {
                updateLabelWithVibration(label: circleYellow, value: savedYellowValue, scaleX: 1.04, scaleY: 1.04)
            }
        } else if sender == sliderRed {
            updateLabelWithVibration(label: sliderValueRed, value: sender.value,  scaleX: 1.04, scaleY: 1.04)
            updateLabelWithVibration(label: progressRed, value: sender.value, scaleX: 1.02, scaleY: 1.02)
            let redUserDefaultsKey = "breakfastredSliderValue"
            if let savedRedValue = UserDefaults.standard.value(forKey: redUserDefaultsKey) as? Float {
                updateLabelWithVibration(label: circleRed, value: savedRedValue, scaleX: 1.04, scaleY: 1.04)
            }
        } else if sender == sliderPurple {
            updateLabelWithVibration(label: sliderValuePurple, value: sender.value, scaleX: 1.04, scaleY: 1.04)
            updateLabelWithVibration(label: progressPurple, value: sender.value, scaleX: 1.02, scaleY: 1.02)
            let purpleUserDefaultsKey = "breakfastpurpleSliderValue"
            if let savedPurpleValue = UserDefaults.standard.value(forKey: purpleUserDefaultsKey) as? Float {
                updateLabelWithVibration(label: circlePurple, value: savedPurpleValue, scaleX: 1.04, scaleY: 1.04)
            }
        }
        saveSliderValues(forSegment: segmentedControl.selectedSegmentIndex)
        circleTotal()
    }
    
    func saveSliderValues(forSegment segment: Int) {
        let segmentKey = segmentKeyForIndex(segment)
        
        // Round the slider values to remove decimal places
        let roundedGreenValue = round(sliderGreen.value)
        let roundedYellowValue = round(sliderYellow.value)
        let roundedRedValue = round(sliderRed.value)
        let roundedPurpleValue = round(sliderPurple.value)

        userDefaults.set(roundedGreenValue, forKey: "\(segmentKey)greenSliderValue")
        userDefaults.set(roundedYellowValue, forKey: "\(segmentKey)yellowSliderValue")
        userDefaults.set(roundedRedValue, forKey: "\(segmentKey)redSliderValue")
        userDefaults.set(roundedPurpleValue, forKey: "\(segmentKey)purpleSliderValue")
    }
    
    func loadDefaults(forSegment segment: Int) {
        let segmentKey = segmentKeyForIndex(segment)
        
        if let savedGreenValue = userDefaults.value(forKey: "\(segmentKey)greenSliderValue") as? Float {
            sliderGreen.value = savedGreenValue
            sliderValueGreen.text = String(format: "%.0f", savedGreenValue)
        }
        
        if let savedYellowValue = userDefaults.value(forKey: "\(segmentKey)yellowSliderValue") as? Float {
            sliderYellow.value = savedYellowValue
            sliderValueYellow.text = String(format: "%.0f", savedYellowValue)
        }
        
        if let savedRedValue = userDefaults.value(forKey: "\(segmentKey)redSliderValue") as? Float {
            sliderRed.value = savedRedValue
            sliderValueRed.text = String(format: "%.0f", savedRedValue)
        }
        
        if let savedPurpleValue = userDefaults.value(forKey: "\(segmentKey)purpleSliderValue") as? Float {
            sliderPurple.value = savedPurpleValue
            sliderValuePurple.text = String(format: "%.0f", savedPurpleValue)
        }
    }
    
    func updateSliderValues() {
        updateLabelWithVibration(label: sliderValueGreen, value: sliderGreen.value, scaleX: 1.03, scaleY: 1.03)
        updateLabelWithVibration(label: sliderValueYellow, value: sliderYellow.value, scaleX: 1.03, scaleY: 1.03)
        updateLabelWithVibration(label: sliderValueRed, value: sliderRed.value, scaleX: 1.03, scaleY: 1.03)
        updateLabelWithVibration(label: sliderValuePurple, value: sliderPurple.value, scaleX: 1.03, scaleY: 1.03)

        if let sliderValueGreenText = sliderValueGreen.text {
            updateLabelWithVibration(label: progressGreen, value: (sliderValueGreenText as NSString).floatValue, scaleX: 1.03, scaleY: 1.03)
        }

        if let sliderValueYellowText = sliderValueYellow.text {
            updateLabelWithVibration(label: progressYellow, value: (sliderValueYellowText as NSString).floatValue, scaleX: 1.03, scaleY: 1.03)
        }

        if let sliderValueRedText = sliderValueRed.text {
            updateLabelWithVibration(label: progressRed, value: (sliderValueRedText as NSString).floatValue, scaleX: 1.03, scaleY: 1.03)
        }

        if let sliderValuePurpleText = sliderValuePurple.text {
            updateLabelWithVibration(label: progressPurple, value: (sliderValuePurpleText as NSString).floatValue,  scaleX: 1.03, scaleY: 1.03)
        }
        
    }
    
    func updateLabelWithVibration(label: UILabel, value: Float, scaleX: CGFloat, scaleY: CGFloat) {
        label.text = String(format: "%.0f", value)

        let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)

        UIView.animate(withDuration: 0.1, animations: {
            label.transform = scaleTransform
        }) { _ in
            UIView.animate(withDuration: 1) {
                label.transform = .identity

            }
        }
    }
    
    func segmentKeyForIndex(_ index: Int) -> String {
        switch index {
        case 0:
            return "breakfast"
        case 1:
            return "lunch"
        case 2:
            return "dinner"
        case 3:
            return "snack"
        default:
            return ""
        }
    }
    
    func segmentName(forIndex index: Int) -> String {
        switch index {
        case 0:
            infoLabel.text = "Kahvaltı için ihtiyaç duyduğun değerleri ayarla"
            return "Kahvaltı"
        case 1:
            infoLabel.text = "Öğle Y. için ihtiyaç duyduğun değerleri ayarla"
            return "Öğle Y."
        case 2:
            infoLabel.text = "Akşam Y. için ihtiyaç duyduğun değerleri ayarla"
            return "Akşam Y"
        case 3:
            infoLabel.text = "Atıştırma için ihtiyaç duyduğun değerleri ayarla"
            return "Atıştırma"
        default:
            return ""
        }
    }
    
    func circleTotal() {
        let meals = ["breakfast", "lunch", "dinner", "snack"]
        let colors = ["green", "yellow", "red", "purple"]
        
        var totalValues = [Float](repeating: 0.0, count: colors.count)
        
        for meal in meals {
            for color in colors {
                if let value = UserDefaults.standard.value(forKey: "\(meal)\(color)SliderValue") as? Float {
                    let colorIndex = colors.firstIndex(of: color)!
                    totalValues[colorIndex] += value
                }
            }
        }
        
        let (greenTotal, yellowTotal, redTotal, purpleTotal) = (totalValues[0], totalValues[1], totalValues[2], totalValues[3])
        
        circleRed.text = String(format: "%.0f", redTotal)
        circleGreen.text = String(format: "%.0f", greenTotal)
        circlePurple.text = String(format: "%.0f", purpleTotal)
        circleYellow.text = String(format: "%.0f", yellowTotal)
        
        
        
    }
}
