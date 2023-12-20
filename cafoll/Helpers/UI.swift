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
    
    var textField1: UITextField!
    var textField2: UITextField!
    var textField3: UITextField!
    var textField4: UITextField!
    var updateButton: UIButton!
    
    var homeviewController: HomeViewController!
    
    func uiTools(homeViewController: HomeViewController) {
           self.homeviewController = homeViewController
           totalBar()
           UiOfCircle()
       }
    func UiOfCircle() {
        // Dairesel ilerleme çubuklarını oluştur
        circularProgressBar1 = CircularProgressBar(frame: CGRect(x: 0, y: 0, width: 150, height: 150), color: .purple)
        circularProgressBar2 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 125, height: 125), color: .red)
        circularProgressBar3 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 100, height: 100), color: .brown)
        circularProgressBar4 = CircularProgressBar(frame: CGRect(x: 12.5, y: 12.5, width: 75, height: 75), color: .green)

        // TextField'ları oluştur
        textField1 = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        textField1.placeholder = "0-100 arası bir değer girin"
        textField1.keyboardType = .numberPad

        textField2 = UITextField(frame: CGRect(x: 0, y: 20, width: 100, height: 40))
        textField2.placeholder = "0-100 arası bir değer girin"
        textField2.keyboardType = .numberPad

        textField3 = UITextField(frame: CGRect(x: 0, y: 40, width: 100, height: 40))
        textField3.placeholder = "0-100 arası bir değer girin"
        textField3.keyboardType = .numberPad

        textField4 = UITextField(frame: CGRect(x: 0, y: 60, width: 100, height: 40))
        textField4.placeholder = "0-100 arası bir değer girin"
        textField4.keyboardType = .numberPad

        // Güncelleme butonu oluştur
        updateButton = UIButton(type: .system)
        updateButton.setTitle("Güncelle", for: .normal)
        updateButton.frame = CGRect(x: 100, y: 0, width: 100, height: 40)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)

        // Add circularProgressBar2 to circularProgressBar1
        circularProgressBar1.addSubview(circularProgressBar2)
        circularProgressBar2.addSubview(circularProgressBar3)
        circularProgressBar3.addSubview(circularProgressBar4)

        circularProgressBar1.setBackgroundLayerColor(color: UIColor.purple.withLightness(1.2))
        circularProgressBar2.setBackgroundLayerColor(color: UIColor.red.withLightness(1.2))
        circularProgressBar3.setBackgroundLayerColor(color: UIColor.brown.withLightness(1.2))
        circularProgressBar4.setBackgroundLayerColor(color: UIColor.green.withLightness(1.2))
        
        // Görünüme ekle
        homeviewController.firstLook.addSubview(circularProgressBar1)
        homeviewController.secondLook.addSubview(textField1)
        homeviewController.secondLook.addSubview(textField2)
        homeviewController.secondLook.addSubview(textField3)
        homeviewController.secondLook.addSubview(textField4)
        homeviewController.secondLook.addSubview(updateButton)
    }
    
    @objc func updateButtonTapped() {
        // Kullanıcının girdiği değerleri al
        if let inputValue1 = textField1.text, let progressValue1 = Float(inputValue1),
           let inputValue2 = textField2.text, let progressValue2 = Float(inputValue2),
           let inputValue3 = textField3.text, let progressValue3 = Float(inputValue3),
           let inputValue4 = textField4.text, let progressValue4 = Float(inputValue4) {

            // Girilen değerleri kullanarak ilerleme çubuklarını güncelle
            let normalizedProgress1 = CGFloat(progressValue1 / 100.0)
            let normalizedProgress2 = CGFloat(progressValue2 / 100.0)
            let normalizedProgress3 = CGFloat(progressValue3 / 100.0)
            let normalizedProgress4 = CGFloat(progressValue4 / 100.0)

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
        applyShadow(to: homeviewController.firstLook, offset: CGSize(width: 0, height: 6), radius: 12)
        applyShadow(to: homeviewController.secondLook, offset: CGSize(width: 0, height: 6), radius: 12)
        applyShadow(to: homeviewController.dateView, offset: CGSize(width: 0, height: 6), radius: 12)
        applyShadow(to: homeviewController.segmentView, offset: CGSize(width: 0, height: 6), radius: 12)
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
