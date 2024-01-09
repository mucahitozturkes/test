//
//  SettingsViewController.swift
//  cafoll
//
//  Created by mücahit öztürk on 5.01.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
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
        circleTotal()
        let initialSegment = segmentedControl.selectedSegmentIndex
        loadDefaults(forSegment: initialSegment)  // Yüklenen defaults, başlangıç segmenti için yapılıyor
        updateSliderValues()
        progressName.text = segmentName(forIndex: initialSegment)
    }

    @IBAction func segmentedControlPanel(_ sender: UISegmentedControl) {
        let segment = segmentedControl.selectedSegmentIndex

        progressName.text = segmentName(forIndex: segment)
        loadDefaults(forSegment: segment)
        updateSliderValues()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateSliderValues()
        saveSliderValues(forSegment: segmentedControl.selectedSegmentIndex)
        circleTotal()
    }

    func saveSliderValues(forSegment segment: Int) {
        let segmentKey = segmentKeyForIndex(segment)
        userDefaults.set(sliderGreen.value, forKey: "\(segmentKey)greenSliderValue")
        userDefaults.set(sliderYellow.value, forKey: "\(segmentKey)yellowSliderValue")
        userDefaults.set(sliderRed.value, forKey: "\(segmentKey)redSliderValue")
        userDefaults.set(sliderPurple.value, forKey: "\(segmentKey)purpleSliderValue")
    }

    func loadDefaults(forSegment segment: Int) {
        let segmentKey = segmentKeyForIndex(segment)

        if let savedGreenValue = userDefaults.value(forKey: "\(segmentKey)greenSliderValue") as? Float {
            sliderGreen.value = savedGreenValue
            sliderValueGreen.text = String(format: "%.2f", savedGreenValue)
        }

        if let savedYellowValue = userDefaults.value(forKey: "\(segmentKey)yellowSliderValue") as? Float {
            sliderYellow.value = savedYellowValue
            sliderValueYellow.text = String(format: "%.2f", savedYellowValue)
        }

        if let savedRedValue = userDefaults.value(forKey: "\(segmentKey)redSliderValue") as? Float {
            sliderRed.value = savedRedValue
            sliderValueRed.text = String(format: "%.2f", savedRedValue)
        }

        if let savedPurpleValue = userDefaults.value(forKey: "\(segmentKey)purpleSliderValue") as? Float {
            sliderPurple.value = savedPurpleValue
            sliderValuePurple.text = String(format: "%.2f", savedPurpleValue)
        }
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
            return "Breakfast"
        case 1:
            return "Lunch"
        case 2:
            return "Dinner"
        case 3:
            return "Snack"
        default:
            return ""
        }
    }
    func circleTotal() {
        let meals = ["breakfast", "lunch", "dinner", "snack"]
        let colors = ["green", "yellow", "red", "purple"]

        var totalValues = [Double](repeating: 0.0, count: colors.count)

        for meal in meals {
            for color in colors {
                if let value = UserDefaults.standard.value(forKey: "\(meal)\(color)SliderValue") as? Double {
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
