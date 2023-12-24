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
    var totalCalori = Float(10)
    var totalProtein = Float(10)
    var totalFat = Float(10)
    var totalCarbon = Float(10)
    
    var caloriValue: Float?
    var proteinValue: Float?
    var fatValue: Float?
    var carbonValue: Float?
    
    var coredata: Coredata!
    
    func uiTools(homeViewController: HomeViewController) {
        self.homeviewController = homeViewController
        setupCoreData()
        
    }

    func setupCoreData() {
        self.coredata = Coredata() // Initialize your Coredata object
        totalBar()
        UiOfCircle()
        updateButtonTapped()
        coredata.fetchMaxValueCircle()
    }
    func UiOfCircle() {
        // Dairesel ilerleme çubuklarını oluştur
        circularProgressBar1 = CircularProgressBar(frame: CGRect(x: 0, y: 0, width: 150, height: 150), color: .systemPurple)
        circularProgressBar2 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 125, height: 125), color: .systemRed)
        circularProgressBar3 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 100, height: 100), color: .systemYellow)
        circularProgressBar4 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 75, height: 75), color: .systemGreen)
        
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
    
    @objc func updateButtonTapped() {
        let setMaxValueCircle = MaxValueCircle(context: self.coredata.context)

       
        if let caloriText = homeviewController.textfieldCalori.text, let caloriValue = Float(caloriText) {
            setMaxValueCircle.maxValueCalori = caloriValue
            self.caloriValue = caloriValue
        }

        if let proteinText = homeviewController.textfieldProtein.text, let proteinValue = Float(proteinText) {
            setMaxValueCircle.maxValueProtein = proteinValue
            self.proteinValue = proteinValue
        }

        if let fatText = homeviewController.textfieldFat.text, let fatValue = Float(fatText) {
            setMaxValueCircle.maxValueFat = fatValue
            self.fatValue = fatValue
        }

        if let carbonText = homeviewController.textfieldCarbon.text, let carbonValue = Float(carbonText) {
            setMaxValueCircle.maxValueCarbon = carbonValue
            self.carbonValue = carbonValue
        }

        // Use optional binding to safely unwrap optionals
        if let caloriValue = caloriValue, let proteinValue = proteinValue, let fatValue = fatValue, let carbonValue = carbonValue {
            coredata.updateOrAddMaxValueCircle(maxValueCalori: caloriValue, maxValueProtein: proteinValue, maxValueFat: fatValue, maxValueCarbon: carbonValue)

            let normalizedProgress1 = CGFloat(totalCalori / caloriValue)
            let normalizedProgress2 = CGFloat(totalProtein / proteinValue)
            let normalizedProgress3 = CGFloat(totalFat / fatValue)
            let normalizedProgress4 = CGFloat(totalCarbon / carbonValue)

            circularProgressBar1.animateProgress(to: normalizedProgress1, duration: 1.0)
            circularProgressBar2.animateProgress(to: normalizedProgress2, duration: 1.0)
            circularProgressBar3.animateProgress(to: normalizedProgress3, duration: 1.0)
            circularProgressBar4.animateProgress(to: normalizedProgress4, duration: 1.0)

        }
    }



    
    //View shadows
    func applyShadow(to view: UIView, opacity: Float = 0.2, offset: CGSize = .zero, radius: CGFloat = 12, cornerRadius: CGFloat = 24) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
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
