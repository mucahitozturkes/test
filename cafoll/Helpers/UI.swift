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
    var totalCalori: Float?
    var totalProtein: Float?
    var totalFat: Float?
    var totalCarbon: Float?

    var caloriValue = Float(2500)
    var proteinValue = Float(80)
    var fatValue = Float(60)
    var carbonValue = Float(50)

    // Your code here
    
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

        if let totalCaloriText = homeviewController.totalCalori.text,
           let totalProteinText = homeviewController.totalPRotein.text,
           let totalFatText = homeviewController.totalFat.text,
           let totalCarbonText = homeviewController.totalCarbon.text,
           let totalCaloriValue = Float(totalCaloriText),
           let totalProteinValue = Float(totalProteinText),
           let totalFatValue = Float(totalFatText),
           let totalCarbonValue = Float(totalCarbonText) {
            
            totalCalori = totalCaloriValue
            totalProtein = totalProteinValue
            totalFat = totalFatValue
            totalCarbon = totalCarbonValue
            
        } else {
            // Handle the case where at least one of the texts is nil or cannot be converted to Float
            print("Error: One or more text values are nil or cannot be converted to Float.")
        }


        
        homeviewController.purpleLabel.text = String(format: "%.0f", caloriValue)
        homeviewController.redLabel.text = String(format: "%.0f", proteinValue)
        homeviewController.yellowLabel.text = String(format: "%.0f", fatValue)
        homeviewController.greenLabel.text = String(format: "%.0f", carbonValue)
        
        let normalizedProgress1 = CGFloat((totalCalori ?? 0) / caloriValue)
        let normalizedProgress2 = CGFloat((totalProtein ?? 0) / proteinValue)
        let normalizedProgress3 = CGFloat((totalFat ?? 0) / fatValue)
        let normalizedProgress4 = CGFloat((totalCarbon ?? 0) / carbonValue)

        circularProgressBar1.animateProgress(to: normalizedProgress1, duration: 1.0)
        circularProgressBar2.animateProgress(to: normalizedProgress2, duration: 1.0)
        circularProgressBar3.animateProgress(to: normalizedProgress3, duration: 1.0)
        circularProgressBar4.animateProgress(to: normalizedProgress4, duration: 1.0)

        
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
