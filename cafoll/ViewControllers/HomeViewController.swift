//
//  HomeViewController.swift
//  cafoll
//
//  Created by mücahit öztürk on 4.12.2023.
//

import UIKit


class HomeViewController: UIViewController {

  
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var datePicker: UIButton!
    @IBOutlet weak var dateView: UIView!
   
    @IBOutlet weak var secondLook: UIView!
    
    @IBOutlet weak var firstLook: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var coredata: Coredata!
    var helper: Helper!
    var ui: Ui!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(helper?.filePath ?? "Not Found")
        helper = Helper()
        coredata = Coredata()
        ui = Ui()
        //Fetch items
        coredata.fetchBreakfast()
        coredata.fetchLunch()
        coredata.fetchDinner()
        coredata.fetchSnack()
        //UI
        ui.uiTools(homeViewController: self)
        setupView()
    }
   
    func setupView() {
        
    }

    


    
}
// MARK: - Home Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        //let row = indexPath.row
        
        cell.textLabel?.text = "hello!"
        
        return cell
    }
}
