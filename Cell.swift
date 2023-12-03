import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var favoriteIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var foodTitleLabel: UILabel!
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        // Favori butonuna basıldığında
        favoriteIndicator.startAnimating() // Indicator'ı başlat
        favoriteButton.isHidden = true // Favori butonunu gizle
        
        // Belirli bir süre sonra eski haline dönmesi için DispatchQueue kullanıyoruz
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 1.5 saniye sonra
            self.favoriteIndicator.stopAnimating() // Indicator'ı durdur
            self.favoriteButton.isHidden = false // Favori butonunu
        }
    }
}
