//
//  UI.swift
//  cafoll
//
//  Created by mücahit öztürk on 5.12.2023.
//

import UIKit

class Ui {
    
    //Circle Bars
    var circularProgressBar1: CircularProgressBar!
    var circularProgressBar2: CircularProgressBar!
    var circularProgressBar3: CircularProgressBar!
    var circularProgressBar4: CircularProgressBar!
    
    var homeviewController: HomeViewController!
    var settingsViewController: SettingsViewController!
    
    var totalCalori: Float?
    var totalProtein: Float?
    var totalFat: Float?
    var totalCarbon: Float?
    
    var coredata: Coredata!
    
    func uiTools(homeViewController: HomeViewController) {
        self.homeviewController = homeViewController
        setupCoreData()
    }

    func setupCoreData() {
      
        totalBar()
        UiOfCircle()
        updateButtonTapped()
    }
    
    func UiOfCircle() {
        // Dairesel ilerleme çubuklarını oluştur
        circularProgressBar1 = CircularProgressBar(frame: CGRect(x: 0, y: 0, width: 150, height: 150), color: UIColor.systemPurple.withAlphaComponent(0.60))
        circularProgressBar2 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 125, height: 125), color: UIColor.systemRed.withAlphaComponent(0.60))
        circularProgressBar3 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 100, height: 100), color: UIColor.systemYellow.withAlphaComponent(0.60))
        circularProgressBar4 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 75, height: 75), color: UIColor.systemGreen.withAlphaComponent(0.60))
        
        // Add circularProgressBar2 to circularProgressBar1
        circularProgressBar1.addSubview(circularProgressBar2)
        circularProgressBar2.addSubview(circularProgressBar3)
        circularProgressBar3.addSubview(circularProgressBar4)

        circularProgressBar1.setBackgroundLayerColor(color: UIColor.systemPurple.withLightness(1.2))
        circularProgressBar2.setBackgroundLayerColor(color: UIColor.systemRed.withLightness(1.2))
        circularProgressBar3.setBackgroundLayerColor(color: UIColor.systemYellow.withLightness(1.2))
        circularProgressBar4.setBackgroundLayerColor(color: UIColor.systemGreen.withLightness(1.2))
        
        // Görünüme ekle
        homeviewController?.firstLook.addSubview(circularProgressBar1)
    }
    
    func circleTotal() -> (Float, Float, Float, Float) {
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

        let greenTotal0 = totalValues[0]
        let yellowTotal1 = totalValues[1]
        let redTotal2 = totalValues[2]
        let purpleTotal3 = totalValues[3]

        return (greenTotal0, yellowTotal1, redTotal2, purpleTotal3)
    }

    @objc func updateButtonTapped() {
          
        guard let totalCaloriText = homeviewController?.totalCalori?.text,
              let totalProteinText = homeviewController?.totalPRotein?.text,
              let totalFatText = homeviewController?.totalFat?.text,
              let totalCarbonText = homeviewController?.totalCarbon?.text,
              let totalCaloriValue = Float(totalCaloriText),
              let totalProteinValue = Float(totalProteinText),
              let totalFatValue = Float(totalFatText),
              let totalCarbonValue = Float(totalCarbonText) else {
        
            return
        }

        // Call the circleTotal function to calculate the total values
        let (greenTotal0, yellowTotal1, redTotal2, purpleTotal3) = circleTotal()

        updateUIWithAnimation(totalCalori: totalCaloriValue,
                              totalProtein: totalProteinValue,
                              totalFat: totalFatValue,
                              totalCarbon: totalCarbonValue,
                              greenTotal: greenTotal0,
                              yellowTotal: yellowTotal1,
                              redTotal: redTotal2,
                              purpleTotal: purpleTotal3,
                              duration: 100.0)
    }

    func updateUIWithAnimation(totalCalori: Float,
                                totalProtein: Float,
                                totalFat: Float,
                                totalCarbon: Float,
                                greenTotal: Float,
                                yellowTotal: Float,
                                redTotal: Float,
                                purpleTotal: Float,
                                duration: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.totalCalori = totalCalori
            self.totalProtein = totalProtein
            self.totalFat = totalFat
            self.totalCarbon = totalCarbon

            let labelValues: [(label: UILabel?, total: Float, current: Float)] = [
                (self.homeviewController?.purpleLabel, purpleTotal, totalCalori),
                (self.homeviewController?.redLabel, redTotal, totalProtein),
                (self.homeviewController?.yellowLabel, yellowTotal, totalFat),
                (self.homeviewController?.greenLabel, greenTotal, totalCarbon)
            ]

            for (label, total, current) in labelValues {
                label?.text = String(Int(total - current))
                label?.isHidden = (total - current < 0)
            }


            let normalizedProgress1 = CGFloat((totalCalori / purpleTotal))
            let normalizedProgress2 = CGFloat((totalProtein / redTotal))
            let normalizedProgress3 = CGFloat((totalFat / yellowTotal))
            let normalizedProgress4 = CGFloat((totalCarbon / greenTotal))

            self.circularProgressBar1.animateProgress(to: normalizedProgress1, duration: duration)
            print("Animation Duration: \(duration)")
            self.circularProgressBar2.animateProgress(to: normalizedProgress2, duration: duration)
            self.circularProgressBar3.animateProgress(to: normalizedProgress3, duration: duration)
            self.circularProgressBar4.animateProgress(to: normalizedProgress4, duration: duration)
        }
    }


    //View shadows
    func applyShadow(to view: UIView, opacity: Float = 0.2, offset: CGSize = .zero, radius: CGFloat = 0, cornerRadius: CGFloat = 24) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
        view.layer.cornerRadius = cornerRadius
    }
    func totalBar() {
        applyShadow(to: homeviewController!.firstLook, offset: CGSize(width: 0, height: 6), radius: 12)
        applyShadow(to: homeviewController!.secondLook, offset: CGSize(width: 0, height: 6), radius: 12)
        applyShadow(to: homeviewController!.dateView, offset: CGSize(width: 0, height: 6), radius: 12)
        applyShadow(to: homeviewController!.segmentView, offset: CGSize(width: 0, height: 6), radius: 12)
      
    }
  
}

//color of Circle Backgrounds
extension UIColor {
    func withLightness(_ factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let adjustedBrightness = min(brightness * factor, 1.0)

        return UIColor(hue: hue, saturation: saturation, brightness: adjustedBrightness, alpha: alpha)
    }
}

