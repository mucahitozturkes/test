import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var foodTitleLabel: UILabel!
    
//    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
//            if sender.isSelected {
//                // Deselect the button and set the heart to empty
//                sender.isSelected = false
//                sender.setImage(UIImage(systemName: "heart"), for: .normal)
//                
//            } else {
//                // Select the button and set the heart to filled
//                sender.isSelected = true
//                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//               
//            }
//        }
//    override func awakeFromNib() {
//            super.awakeFromNib()
//            // Set the initial state of the button, e.g., not selected and with the empty heart icon
//            favoriteButton.isSelected = false
//            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        }
}
