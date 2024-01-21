//
//  Cell.swift
//  cafoll
//
//  Created by mücahit öztürk on 22.11.2023.
//

import UIKit

class Cell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var lastSearchImage: UIImageView!
    @IBOutlet weak var foodTitleLabelUI: UILabel!
}

class HomeCell: UITableViewCell {
    @IBOutlet weak var greenProgressInfo: UIProgressView!
    @IBOutlet weak var yellowProgressInfo: UIProgressView!
    @IBOutlet weak var redProgressInfo: UIProgressView!
    @IBOutlet weak var purpleProgressInfo: UIProgressView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    let maxPurple = 500
    let maxRed = 30
    let maxYellow = 30
    let maxGreen = 30
    
    var homeVC: HomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadowsAndColors()
        
    }
    
    func setShadowsAndColors() {
        colorView.layer.cornerRadius = 8
    
    }
    func updateProgressViews(calories: Float, fat: Float, protein: Float, carbs: Float, maxGreen: Float, maxYellow: Float, maxRed: Float, maxPurple: Float, duration: TimeInterval = 1.0) {
            // Set initial progress to 0.0
            purpleProgressInfo.progress = 0.00
            redProgressInfo.progress = 0.00
            yellowProgressInfo.progress = 0.00
            greenProgressInfo.progress = 0.00
        
            
            // Calculate target progress values
            let targetProgressPurple = min(Float(calories) / maxPurple, 1.0)
            let targetProgressYellow = min(Float(fat) / maxYellow, 1.0)
            let targetProgressRed = min(Float(protein) / maxRed, 1.0)
            let targetProgressGreen = min(Float(carbs) / maxGreen, 1.0)
            
            // Animate progress to target values
            UIView.animate(withDuration: duration) {
                self.greenProgressInfo.setProgress(targetProgressGreen, animated: true)
                self.yellowProgressInfo.setProgress(targetProgressYellow, animated: true)
                self.redProgressInfo.setProgress(targetProgressRed, animated: true)
                self.purpleProgressInfo.setProgress(targetProgressPurple, animated: true)
            }
            
        
        }
}

