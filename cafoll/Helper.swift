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
    var foods: [Foods]?
    //Fetch Foods
    func fetchFoods() {
        do {
        let request = Foods.fetchrequest()
        self.foods = try context.fetch(request)
        } 
        catch {
        print(error)
        }
    }
}

