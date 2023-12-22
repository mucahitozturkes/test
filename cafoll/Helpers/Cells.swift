//
//  Cell.swift
//  cafoll
//
//  Created by mücahit öztürk on 22.11.2023.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var favoriteIndicatorUI: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButtonUI: UIButton!
    @IBOutlet weak var moreInfoButtonUI: UIButton!
    @IBOutlet weak var foodTitleLabelUI: UILabel!
}

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadowsAndColors() // Corrected method name
    }
    
    func setShadowsAndColors() {
        colorView.layer.cornerRadius = 8
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.systemIndigo.cgColor
    }
}

