import UIKit

class Helper {
    var homeViewController = HomeViewController()
    
    func helperTools(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
    }

    // Haptic
    func generateHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
  
}
