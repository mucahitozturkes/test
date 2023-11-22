//
//  Helper.swift
//  cafoll
//
//  Created by mücahit öztürk on 22.11.2023.
//

import UIKit

class Helper {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
}
