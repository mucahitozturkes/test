//
//  UI.swift
//  cafoll
//
//  Created by mücahit öztürk on 5.12.2023.
//

import UIKit

class Ui {
    
    var homeviewController: HomeViewController!
    
    func uiTools(homeViewController: HomeViewController) {
           self.homeviewController = homeViewController
           totalBar()
           drawNestedCircles()
       }
    
    func totalBar() {
        homeviewController.firstLook.layer.shadowColor = UIColor.black.cgColor
        homeviewController.firstLook.layer.shadowOpacity = 0.5
        homeviewController.firstLook.layer.shadowOffset = CGSize(width: 0, height: 1)
        homeviewController.firstLook.layer.shadowRadius = 2
        homeviewController.firstLook.layer.cornerRadius = 24
       
        homeviewController.secondLook.layer.shadowColor = UIColor.black.cgColor
        homeviewController.secondLook.layer.shadowOpacity = 0.5
        homeviewController.secondLook.layer.shadowOffset = CGSize(width: 0, height: 1)
        homeviewController.secondLook.layer.shadowRadius = 2
        homeviewController.secondLook.layer.cornerRadius = 24
      
        homeviewController.dateView.layer.shadowColor = UIColor.black.cgColor
        homeviewController.dateView.layer.shadowOpacity = 0.5
        homeviewController.dateView.layer.shadowOffset = CGSize(width: 0, height: 1)
        homeviewController.dateView.layer.shadowRadius = 2
        homeviewController.dateView.layer.cornerRadius = 24
     
        homeviewController.segmentView.layer.shadowColor = UIColor.black.cgColor
        homeviewController.segmentView.layer.shadowOpacity = 0.5
        homeviewController.segmentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        homeviewController.segmentView.layer.shadowRadius = 2
        homeviewController.segmentView.layer.cornerRadius = 24
    }
    
    func drawNestedCircles() {
        let outerRadius: CGFloat = 60.0

        drawCircle(radius: outerRadius - 0, lineWidth: 12.0, strokeColor: UIColor.purple)
        
        // İkinci iç içe daire
        drawCircle(radius: outerRadius - 15.0, lineWidth: 11.0, strokeColor: UIColor.red)
        
        // Üçüncü iç içe daire
        drawCircle(radius: outerRadius - 30.0, lineWidth: 10.0, strokeColor: UIColor.green)
        
        // Dördüncü iç içe daire
        drawCircle(radius: outerRadius - 45.0, lineWidth: 10.0, strokeColor: UIColor.yellow)
    }

    func drawCircle(radius: CGFloat, lineWidth: CGFloat, strokeColor: UIColor) {
        // Dairenin çizileceği frame'yi belirle
        let circleFrame = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        
        // UIBezierPath oluştur
        let circlePath = UIBezierPath(ovalIn: circleFrame)
        
        // CAShapeLayer oluştur
        let circleLayer = CAShapeLayer()
        
        // Path'i belirtilen layer'a ata
        circleLayer.path = circlePath.cgPath
        
        // Dairenin içini boş bırak
        circleLayer.fillColor = UIColor.clear.cgColor
        
        // Kenar rengi ve kalınlığını ayarla
        circleLayer.strokeColor = strokeColor.cgColor
        circleLayer.lineWidth = lineWidth
        
        // Dairenin konumunu belirle (hepsini aynı konumda çiziyoruz, isteğe bağlı olarak değiştirebilirsiniz)
        circleLayer.position = CGPoint(x: homeviewController.firstLook.bounds.midX - radius, y: homeviewController.firstLook.bounds.midY - radius)
        
        // Gölge ekleyerek daha belirgin bir görünüm elde et
        circleLayer.shadowColor = UIColor.black.cgColor
        circleLayer.shadowOpacity = 0.5
        circleLayer.shadowOffset = CGSize(width: 0, height: 1)
        circleLayer.shadowRadius = 2
      
        // Layer'ı firstLook içine ekle
        homeviewController.firstLook.layer.addSublayer(circleLayer)
    }
}
