//
//  Helper.swift
//  cafoll
//
//  Created by mücahit öztürk on 4.12.2023.
//

import UIKit


class Helper {
    
    //Haptic
    func generateHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
}
