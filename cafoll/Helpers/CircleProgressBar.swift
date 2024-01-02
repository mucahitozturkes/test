//
//  CircleProgressBar.swift
//  cafoll
//
//  Created by mücahit öztürk on 20.12.2023.
//
import UIKit

class CircularProgressBar: UIView {

    private var backgroundLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    private var baseColor: UIColor = .clear

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundLayer(color: .black)
        setupProgressLayer(color: .blue)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBackgroundLayer(color: .black)
        setupProgressLayer(color: .blue)
    }

    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        setupProgressLayer(color: color)
        baseColor = color
    }

    private func setupBackgroundLayer(color: UIColor) {
            let circularPath = UIBezierPath(
                arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                radius: bounds.width / 2 - 10,
                startAngle: -.pi / 2,
                endAngle: 2 * .pi - .pi / 2,
                clockwise: true
            )

            backgroundLayer = CAShapeLayer()
            backgroundLayer.path = circularPath.cgPath
            backgroundLayer.strokeColor = color.withAlphaComponent(0.1).cgColor
            backgroundLayer.fillColor = UIColor.clear.cgColor
            backgroundLayer.lineWidth = 10.0

            layer.addSublayer(backgroundLayer)
        }

    private func setupProgressLayer(color: UIColor) {
           let circularPath = UIBezierPath(
               arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
               radius: bounds.width / 2 - 10,
               startAngle: -.pi / 2,
               endAngle: 2 * .pi - .pi / 2,
               clockwise: true
           )

           progressLayer = CAShapeLayer()
           progressLayer.path = circularPath.cgPath
           progressLayer.strokeColor = color.cgColor
           progressLayer.fillColor = UIColor.clear.cgColor
           progressLayer.lineWidth = 10.0
           progressLayer.strokeEnd = 0.0

           layer.addSublayer(progressLayer)
       }

    func setBackgroundLayerColor(color: UIColor) {
            backgroundLayer.strokeColor = color.withAlphaComponent(0.1).cgColor
        }
  

    func animateProgress(to value: CGFloat, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = value
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        progressLayer.strokeEnd = value
        progressLayer.add(animation, forKey: "animateProgress")
    }



}
